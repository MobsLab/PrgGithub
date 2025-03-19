# -*- coding: utf-8 -*-
"""
Created on Mon Jan 22 09:15:54 2024

@author: ellac
"""

import torch
import torch.nn as nn
import torch.optim as optim
from sklearn.model_selection import KFold
from sklearn.metrics import confusion_matrix, classification_report
import seaborn as sns
import matplotlib.pyplot as plt
from process_MLP_RNN import load_and_preprocess_data

# Model Definition
class SimpleNN_1H(nn.Module):
    def __init__(self, input_size, output_size):
        super(SimpleNN_1H, self).__init__()
        self.fc1 = nn.Linear(input_size, 64) # input layer
        self.relu = nn.ReLU()
        self.fc2 = nn.Linear(64, 32) # hidden layer
        self.fc3 = nn.Linear(32, output_size)  # output layer

    def forward(self, x):
        x = self.relu(self.fc1(x))
        x = self.relu(self.fc2(x))
        x = self.fc3(x)
        return x

class SimpleNN_3H(nn.Module):
    def __init__(self, input_size, output_size):
        super(SimpleNN_3H, self).__init__()
        self.fc1 = nn.Linear(input_size, 128) # Input layer
        self.relu = nn.ReLU()
        self.fc2 = nn.Linear(128, 64) # First hidden layer
        self.fc3 = nn.Linear(64, 32) # Second hidden layer
        self.fc4 = nn.Linear(32, 16) # Third hidden layer
        self.fc5 = nn.Linear(16, output_size) # Output layer

    def forward(self, x):
        x = self.relu(self.fc1(x))
        x = self.relu(self.fc2(x))
        x = self.relu(self.fc3(x))
        x = self.relu(self.fc4(x))
        x = self.fc5(x)
        return x
    
# Function for defining the neural network model
def define_model(model_type, input_size, output_size):
    if model_type == 'SimpleNN_1H':
        return SimpleNN_1H(input_size, output_size)
    elif model_type == 'SimpleNN_3H':
        return SimpleNN_3H(input_size, output_size)

# Function for training and cross-validation
def train_and_cross_validate(model, X_train, y_train, 
                             criterion, optimizer, num_epochs=10):
    """
    Train and cross-validate a PyTorch model using k-fold cross-validation.

    Parameters:
    - model (torch.nn.Module): The PyTorch model to be trained and cross-validated.
    - X_train (torch.Tensor): The input features for the training dataset.
    - y_train (torch.Tensor): The target labels for the training dataset.
    - criterion (torch.nn.Module): The loss function used to compute the loss during training.
    - optimizer (torch.optim.Optimizer): The optimization algorithm used to update the model's parameters.
    - num_epochs (int): The number of training epochs. Default is set to 10.

    Returns:
    - float: Mean validation accuracy across all folds.

    This function performs k-fold cross-validation, where the training dataset is split into k folds (k=5 by default).
    For each fold, the model is trained over a specified number of epochs, and validation accuracy is computed.
    The mean validation accuracy across all folds is returned as the function output.
    """
    kf = KFold(n_splits=5, shuffle=True, random_state=42)

    mean_validation_accuracy = 0.0

    for fold, (train_idx, val_idx) in enumerate(kf.split(X_train)):
        X_fold_train, X_fold_val = X_train[train_idx], X_train[val_idx]
        y_fold_train, y_fold_val = y_train[train_idx], y_train[val_idx]

        for epoch in range(num_epochs):
            # Training
            outputs = model(X_fold_train)
            loss = criterion(outputs, y_fold_train)
            optimizer.zero_grad()
            loss.backward()
            optimizer.step()

            print(f'Fold [{fold+1}/5], Epoch [{epoch+1}/{num_epochs}], Loss: {loss.item():.4f}')

        # Validation
        with torch.no_grad():
            val_outputs = model(X_fold_val)
            _, val_predicted = torch.max(val_outputs, 1)
            val_accuracy = (val_predicted == y_fold_val).sum().item() / len(y_fold_val)

        mean_validation_accuracy += val_accuracy
        print(f'Fold [{fold+1}/5], Validation Accuracy: {val_accuracy}')

    # Compute the mean validation accuracy
    mean_validation_accuracy /= kf.n_splits
    print(f'Mean Validation Accuracy: {mean_validation_accuracy:.4f}')

    return mean_validation_accuracy


# Function for evaluating the model on the test set
def evaluate_model(model, X_test, y_test):
    """
    Evaluate a PyTorch model on a test dataset.

    Parameters:
    - model (torch.nn.Module): The PyTorch model to be evaluated.
    - X_test (torch.Tensor): The input features for the test dataset.
    - y_test (torch.Tensor): The target labels for the test dataset.

    Returns:
    - Tuple: A tuple containing test accuracy (float) and predicted labels (torch.Tensor).

    This function evaluates the provided PyTorch model on a test dataset. It computes the test accuracy
    by comparing the model's predicted labels to the true labels. The function returns a tuple containing
    the test accuracy and the predicted labels for further analysis or visualization.
    """
    with torch.no_grad():
        test_outputs = model(X_test)
        _, test_predicted = torch.max(test_outputs, 1)
        test_accuracy = (test_predicted == y_test).sum().item() / len(y_test)

    print(f'Test Accuracy: {test_accuracy}')

    return test_accuracy, test_predicted


# Function for displaying results
def display_results(y_test, test_predicted, label_mapping):
    """
    Display confusion matrix and classification report, and return the results.

    Parameters:
    - y_test: True labels.
    - test_predicted: Predicted labels.
    - label_mapping: Dictionary mapping label indices to class names.

    Returns:
    - results (dict): Dictionary containing confusion matrix and classification report.
    - figure (matplotlib.figure.Figure): Matplotlib figure.
    """

    # Confusion Matrix
    conf_matrix = confusion_matrix(y_test.numpy(), test_predicted.numpy())

    # Classification Report
    class_report = classification_report(y_test.numpy(), test_predicted.numpy(), 
                                          target_names=label_mapping.keys(), output_dict=True)

    # Create a figure
    figure, ax = plt.subplots(figsize=(8, 6))

    # Display Confusion Matrix using Seaborn heatmap
    sns.heatmap(conf_matrix, annot=True, fmt='d', cmap='Blues', 
                xticklabels=label_mapping.keys(), yticklabels=label_mapping.keys(), ax=ax)
    ax.set_xlabel('Predicted')
    ax.set_ylabel('Actual')

    # Modify the title to include additional metrics
    precision = class_report['weighted avg']['precision']
    recall = class_report['weighted avg']['recall']
    f1_score = class_report['weighted avg']['f1-score']

    title = f'Confusion Matrix\nPrecision: {precision:.2f}, Recall: {recall:.2f}, F1-Score: {f1_score:.2f}'
    ax.set_title(title)

    # Return the figure along with results
    return {
        'confusion_matrix': conf_matrix,
        'classification_report': class_report
    }, figure


# Main function to orchestrate the entire process
def train_and_evaluate_MLP(mice_data, mouse_id, epoch_names, variable_names, model_type):
    """
    Train and evaluate an MLP model for a classification task.

    Parameters:
    - mice_data (dict): Dictionary containing mouse data.
    - mouse_id (str): Identifier for the mouse.
    - epoch_names (list): List of epoch names for different conditions.
    - variable_names (list): List of variable names for input features.
    - model_type (str): Type of MLP model to use.

    Returns:
    - results (dict): Dictionary containing mean validation accuracy, test accuracy, and other metrics.
    - figures (list): List of Matplotlib figures (if return_figures is True).
    """

    X_train, y_train, X_test, y_test, label_mapping = load_and_preprocess_data(
        mice_data, mouse_id, epoch_names, variable_names)

    # Model Definition
    input_size = len(variable_names)
    output_size = len(label_mapping)
    model = define_model(model_type, input_size, output_size)
    criterion = nn.CrossEntropyLoss()
    optimizer = optim.Adam(model.parameters(), lr=0.01)

    # Model Training and Cross-Validation
    mean_val_accuracy = train_and_cross_validate(model, X_train, y_train, 
                                                 criterion, optimizer, num_epochs=10)

    # Model Evaluation on Test Set
    test_accuracy, test_predicted = evaluate_model(model, X_test, y_test)

    # Display Results
    results, figure = display_results(y_test, test_predicted, label_mapping)

    return {
        'mean_validation_accuracy': mean_val_accuracy,
        'test_accuracy': test_accuracy,
        **results
    }, figure
