# -*- coding: utf-8 -*-
"""
Created on Mon Jan 22 17:42:47 2024

@author: ellac
"""

import numpy as np
import torch
import torch.nn as nn
import torch.optim as optim
import torch.nn.functional as F
from sklearn.model_selection import ParameterGrid
import matplotlib.pyplot as plt
from process_NN import preprocess_data_RNN, create_train_test_loaders

# Define the LSTM model
# Define an LSTM model class with PyTorch's neural network module
class LSTMModel(nn.Module):
    # Initialize the model architecture
    def __init__(self, input_size, hidden_size, output_size, dropout_rate):
        # Call the parent class's constructor
        super(LSTMModel, self).__init__()
        # LSTM layer: Processes input sequences and captures temporal dependencies
        self.lstm = nn.LSTM(input_size, hidden_size, batch_first=True)
        # Dropout layer: Reduces overfitting by randomly "dropping out" some activations
        self.dropout = nn.Dropout(p=dropout_rate)
        # Fully connected layer: Produces the final output from LSTM hidden states
        self.fc = nn.Linear(hidden_size, output_size)

    # Forward method: Defines how input is processed to produce output
    def forward(self, x):
        # Pass input sequences through the LSTM layer
        out, _ = self.lstm(x)
        # Apply ReLU activation and dropout for regularization
        out = self.dropout(F.relu(out))
        # Apply fully connected layer to produce the final output sequence
        out = self.fc(out)
        # Return the final output sequence
        return out
    
    
# Define a function for grid search with early stopping
def grid_search(train_loader, test_loader, input_size, 
                output_size, sequence_length=10, 
                params_grid = {'hidden_size': [1, 2, 4, 8, 16, 32, 64, 128],
                               'learning_rate': [0.0001, 0.0005, 0.001, 0.005, 0.01],
                               'dropout_rate': [0.1, 0.2, 0.3, 0.5, 0.7, 0.9]}):
    """
    Perform grid search to find the best hyperparameters for an LSTM model.

    Parameters:
    - train_loader (DataLoader): DataLoader for the training set.
    - test_loader (DataLoader): DataLoader for the test set.
    - input_size (int): Number of features in the input.
    - output_size (int): Number of output features.
    - sequence_length (int, optional): Length of input sequences. Default is 10.
    - params_grid (dict): Dictionary containing hyperparameter values to be tested.

    Returns:
    - best_params (dict): Dictionary containing the best hyperparameter values.
    - best_test_loss (float): Best test loss achieved during grid search.
    """

    best_params = None
    best_test_loss = float('inf')

    for params in ParameterGrid(params_grid):
        print(f"\nTesting parameters: {params}")
        
        # Instantiate the model
        model = LSTMModel(input_size, params['hidden_size'], output_size, 
                          params['dropout_rate'])

        # Define the loss function and optimizer
        criterion = nn.MSELoss()
        optimizer = optim.Adam(model.parameters(), lr=params['learning_rate'])

        # Train and evaluate the model with early stopping
        train_losses, test_losses, test_loss, test_outputs = train_and_evaluate_RNN(
            model, train_loader, test_loader, criterion, optimizer)

        # Check if the current model has the best test loss
        if test_loss < best_test_loss:
            best_test_loss = test_loss
            best_params = params
            
    print("\nGrid Search Results:")
    print(f"Best Parameters: {best_params}")
    print(f"Best Test Loss: {best_test_loss}")

    return best_params, best_test_loss

# Define a function to train and evaluate the model 
def train_and_evaluate_RNN(model, train_loader, test_loader, criterion, 
                            optimizer, num_epochs=100, patience=10):
    """
    Train and evaluate an RNN model using PyTorch.
    
    This function takes an RNN model, training and testing data loaders, a loss criterion, an optimizer, 
    and optional parameters for the number of epochs and early stopping. It trains the model on the 
    training data, evaluates it on the test data, and returns the training and testing losses along 
    with the best test loss achieved during training.
    
    Parameters:
    - model: The RNN model to be trained and evaluated.
    - train_loader: DataLoader for the training set.
    - test_loader: DataLoader for the test set.
    - criterion: Loss criterion used for both training and testing.
    - optimizer: Optimization algorithm for updating the model parameters.
    - num_epochs: Number of training epochs (default is 100).
    - patience: Number of epochs without improvement for early stopping (default is 10).
    
    Returns:
    - train_losses: List of average training losses for each epoch.
    - test_losses: List of testing losses for each epoch.
    - best_loss: Best test loss achieved during training.
    """

    # Lists to store training and testing losses during training
    train_losses = []
    test_losses = []

    # Initial value for the best test loss, used for early stopping
    best_loss = float('inf')

    # Counter for the number of epochs without improvement
    no_improvement_count = 0

    # Minimum change in test loss to be considered as improvement for early stopping
    min_delta = 0.001
    
    # Loop through epochs
    for epoch in range(num_epochs):
        # Set the model to training mode
        model.train()

        # Initialize training loss for the epoch
        epoch_train_loss = 0.0

        # Iterate through batches in the training loader
        for inputs, targets in train_loader:
            # Zero the gradients, backward pass, and optimization step
            optimizer.zero_grad()
            outputs = model(inputs)
            loss = criterion(outputs, targets)
            loss.backward()
            optimizer.step()

            # Accumulate the loss for each batch
            epoch_train_loss += loss.item()

        # Average training loss over all batches
        epoch_train_loss /= len(train_loader)
        train_losses.append(epoch_train_loss)

        # Set the model to evaluation mode (no gradient computation)
        model.eval()

        # Initialize test loss for the epoch
        epoch_test_loss = 0.0

        # Iterate through batches in the test loader
        with torch.no_grad():
            for inputs, targets in test_loader:
                test_outputs = model(inputs)
                test_loss = criterion(test_outputs, targets)
                epoch_test_loss += test_loss.item()

            # Average test loss over all batches
            epoch_test_loss /= len(test_loader)
            test_losses.append(epoch_test_loss)

        print(f'Epoch [{epoch+1}/{num_epochs}], Train. Loss: {epoch_train_loss:.4f}, Test Loss: {epoch_test_loss:.4f}')
        
        # Early stopping check
        if epoch_test_loss < best_loss - min_delta:
            best_loss = epoch_test_loss
            no_improvement_count = 0
        else:
            no_improvement_count += 1
            
        # Break the training loop if there's no improvement for 'patience' epochs
        if no_improvement_count >= patience:
            print(f'Early stopping after {epoch+1} epochs without improvement.')
            break

    # Return the training and testing losses, along with the best test loss
    return train_losses, test_losses, best_loss


def predict_outputs(model, X_pred):
    """
    Predict outputs using a trained PyTorch model.

    This function takes a PyTorch model and input data for prediction, converts the input data to a PyTorch tensor,
    and performs inference using the trained model. The predicted outputs are then converted to a NumPy array 
    and returned.

    Parameters:
    - model: Trained PyTorch model for making predictions.
    - X_pred: Input data for which predictions are to be made.

    Returns:
    - predictions: NumPy array containing the predicted outputs.
    """
    
    # Set the model to evaluation mode (no gradient computation)
    model.eval()

    # Convert input data to PyTorch tensor
    X_pred_tensor = torch.from_numpy(X_pred).float()

    # Perform inference without gradient computation
    with torch.no_grad():
        predictions = model(X_pred_tensor)
    
    # Convert the predicted outputs to a NumPy array
    return predictions.numpy()


# Plot the training and test loss over epochs
def plot_losses(train_losses, test_losses):
    """
    Plot the training and test losses over epochs.

    This function takes lists of training and test losses over multiple epochs and creates a line plot 
    to visualize the changes in loss values during training. The x-axis represents epochs, and the y-axis 
    represents the corresponding loss values. The resulting plot shows the trend of both training and 
    test losses over the training period. The final train and test losses are also printed on the plot.

    Parameters:
    - train_losses: List of training losses for each epoch.
    - test_losses: List of test losses for each epoch.
    - final_train_loss: Final training loss value.
    - final_test_loss: Final test loss value.

    Returns:
    - None (the plot is displayed using Matplotlib).
    """
    
    # Plot the training and test loss over epochs
    plt.plot(train_losses, label='Training Loss')
    plt.plot(test_losses, label='Test Loss')
    plt.xlabel('Epoch')
    plt.ylabel('Loss')
    plt.legend()
    plt.title('Training and Test Losses Over Epochs')

    # Display the final train and test losses on the plot
    plt.annotate(f'Final Train Loss: {train_losses[-1]:.4f}', 
                 xy=(1, train_losses[-1]), xytext=(8, 0), 
                 xycoords=('axes fraction', 'data'), textcoords='offset points',
                 fontsize=8, ha='left', va='center', color='blue')

    plt.annotate(f'Final Test Loss: {test_losses[-1]:.4f}', 
                 xy=(1, test_losses[-1]), xytext=(8, 0), 
                 xycoords=('axes fraction', 'data'), textcoords='offset points',
                 fontsize=8, ha='left', va='center', color='orange')

    plt.show()



# Compare predictions with ground truth
def plot_pred_vs_target(predictions, ground_truth):
    """
    Plot model predictions against ground truth.

    This function takes two sets of data, the predictions made by a model and the corresponding ground truth,
    and creates a side-by-side plot to compare them. The left subplot shows the model predictions,
    while the right subplot shows the ground truth. Each subplot represents the data as an image, 
    where the x-axis represents the time step, the y-axis represents the unit index, and the color intensity
    indicates the values. Additionally, the Pearson correlation coefficient between predictions and 
    ground truth is computed and displayed on the plot.

    Parameters:
    - predictions: Array of model predictions.
    - ground_truth: Array of ground truth values.

    Returns:
    - None (the plot is displayed using Matplotlib).
    """
    
    # Plot model predictions
    plt.subplot(1, 2, 1)
    im = plt.imshow(np.vstack(predictions).T, aspect='auto', cmap='viridis')
    plt.xlabel('Time Step')
    plt.ylabel('Unit Index')
    plt.title('Model Predictions')
    plt.colorbar(im, label='Firing rate')  # Add colorbar

    # Plot ground truth
    plt.subplot(1, 2, 2)
    im = plt.imshow(np.vstack(ground_truth).T, aspect='auto', cmap='viridis')
    plt.xlabel('Time Step')
    plt.ylabel('Unit Index')
    plt.title('Ground Truth')
    plt.colorbar(im, label='Firing rate')  # Add colorbar

    # Compute and display Pearson correlation coefficient
    # correlation_coefficient = np.corrcoef(np.vstack(predictions), np.vstack(ground_truth))[0, 1]
    # plt.suptitle(f'Pearson Correlation: {correlation_coefficient:.2f}', y=1.02)
    plt.suptitle('RNN LSTM vs Ground Truth predictions of spike trains')

    plt.tight_layout()
    plt.show()


# Function to summarize the LSTM model
def Summary_RNN(mice_data, mouse_id, spike_times_data, 
                features=['Accelero', 'BreathFreq', 'Heartrate', 'LinPos'], 
                best_params={'dropout_rate': 0.2, 'hidden_size': 1, 'learning_rate': 0.01},
                sequence_length=10, val_test_size=0.3, batch_size=32, 
                random_state=42, num_epochs=100, 
                patience=10, grid_search=False):
    """
    Train and evaluate an RNN model, and display summary plots.

    Parameters:
    - mice_data (dict): Dictionary containing mouse data.
    - mouse_id (str): Identifier for the mouse.
    - spike_times_data (dict): Dictionary containing spike times data.
    - features (list): List of feature names to include. Default features are ['Accelero', 'BreathFreq', 'Heartrate', 'LinPos'].
    - best_params (dict): Dictionary containing the best hyperparameter values.
    - sequence_length (int): Length of input sequences. Default is 10.
    - val_test_size (float): Fraction of data used for validation and testing. Default is 0.3.
    - batch_size (int): Batch size for DataLoader. Default is 32.
    - random_state (int): Random seed for reproducibility. Default is 42.
    - num_epochs (int): Number of training epochs (default is 100).
    - patience (int): Number of epochs without improvement for early stopping (default is 10).
    - grid_search (bool): Perform grid search if True, otherwise use provided best_params.

    Returns:
    - figures (list): List containing the Matplotlib figures generated during the summary.
    """

    # Initialize the list to store figures
    figures = []

    # Preprocess data for RNN
    features_df, spikes_RNN = preprocess_data_RNN(mice_data, mouse_id, spike_times_data, features)

    # Create train and test loaders
    train_loader, test_loader, X_pred, y_pred = create_train_test_loaders(features_df, spikes_RNN,
                                                                         sequence_length=sequence_length,
                                                                         val_test_size=val_test_size,
                                                                         batch_size=batch_size,
                                                                         random_state=random_state)

    if grid_search:
        # Define the grid of hyperparameters to search
        params_grid = {
            'hidden_size': [1, 2, 4, 8, 16, 32, 64, 128],
            'learning_rate': [0.0001, 0.0005, 0.001, 0.005, 0.01],
            'dropout_rate': [0.1, 0.2, 0.3, 0.5, 0.7, 0.9]
        }

        # Perform grid search with early stopping
        best_params, best_test_loss = grid_search(params_grid, train_loader, test_loader, 
                                                  input_size=features_df.shape[1], 
                                                  output_size=spikes_RNN.shape[1], 
                                                  sequence_length=sequence_length)
    else:
        # Use provided best_params
        best_params = best_params

    # Instantiate the LSTM model with the best hyperparameters
    lstm_model = LSTMModel(input_size=features_df.shape[1], 
                           hidden_size=best_params['hidden_size'], 
                           output_size=spikes_RNN.shape[1], 
                           dropout_rate=best_params['dropout_rate'])

    # Define the loss function and optimizer
    criterion = torch.nn.MSELoss()
    optimizer = torch.optim.Adam(lstm_model.parameters(), lr=best_params['learning_rate'])

    # Train and evaluate the LSTM model
    train_losses, test_losses, _ = train_and_evaluate_RNN(lstm_model, train_loader, 
                                                         test_loader, criterion, optimizer, 
                                                         num_epochs=num_epochs, patience=patience)

    # Plot the training and test loss over epochs
    fig_losses = plt.figure()
    plot_losses(train_losses, test_losses)
    figures.append(fig_losses)

    # Make predictions on the test set
    with torch.no_grad():
        test_outputs = lstm_model(torch.from_numpy(X_pred).float())
    
    # Plot predictions vs. ground truth
    fig_pred_vs_target = plt.figure()
    plot_pred_vs_target(test_outputs.numpy(), y_pred)
    figures.append(fig_pred_vs_target)

    return figures




