FROM tensorflow/tensorflow:1.13.1-gpu-py3


#COPY libcudnn7_7.6.1.34-1+cuda10.0_amd64.deb /
#COPY libcudnn7-dev_7.6.1.34-1+cuda10.0_amd64.deb /

#RUN dpkg -i /libcudnn7_7.6.1.34-1+cuda10.0_amd64.deb
#RUN dpkg -i /libcudnn7-dev_7.6.1.34-1+cuda10.0_amd64.deb

RUN python -mpip install matplotlib==3.0.3
RUN pip install tqdm==4.32.1
RUN pip install scikit-learn==0.21.2
RUN pip install oauth2client==4.1.3
RUN pip install gspread==3.1.0
RUN pip install tables==3.5.2