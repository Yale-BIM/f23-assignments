# update pip if need be
pip3 install --user -U pip

# install tensorflow and other python deps
pip3 install -U --user tensorflow==2.13.1 tensorboard==2.13.0 scipy==1.10.1 matplotlib==3.7.3 scikit-learn==1.3.1 gdown==4.7.1 testresources==2.0.1

# install urdf parser for imitation learning 
pip3 install --user -U urdf-parser-py==0.0.4
