from flask import Flask, request, jsonify
import joblib
import pandas as pd
from sklearn.preprocessing import OneHotEncoder
from sklearn.preprocessing import StandardScaler
import pickle


app = Flask(__name__)

model = joblib.load('model_svr.pkl')
encoder = joblib.load('encoder.pickle')

def preprocess_data(data):
    df = pd.DataFrame(data, index=[0])
    
    df.drop(['MODEL YEAR', 'FUEL CONSUMPTION CITY (L/100)', 'FUEL CONSUMPTION HWY (L/100)', 'COMB (mpg)', 'Smog Rating'], axis=1, inplace=True)
    
    enc_make = {'Audi': 0.1, 'BMW': 0.2, 'Ford': 0.3, 'Honda': 0.4, 'Mercedes-Benz': 0.5, 'Toyota': 0.6, 'Volkswagen': 0.7}
    df['ENC_MAKE'] = df['MAKE'].apply(lambda x: enc_make.get(x, 0))
    df.drop(['MAKE'], axis=1, inplace=True)
    
    enc_model = {'A3': 0.1, 'A4': 0.2, 'Civic': 0.3, 'Corolla': 0.4, 'F150': 0.5, 'Golf': 0.6, 'Mazda3': 0.7}
    df['ENC_MODEL'] = df['MODEL(# = high output engine)'].apply(lambda x: enc_model.get(x, 0))
    df.drop(['MODEL(# = high output engine)'], axis=1, inplace=True)
    
    one_hot_df = df[['FUEL TYPE', 'VEHICLE CLASS', 'TRANSMISSION']].copy()
    one_hot_df.reset_index(inplace=True)
    one_hot_df.drop(['index'], axis=1, inplace=True)
    
    df_cat = pd.DataFrame(encoder.transform(one_hot_df), columns=encoder.get_feature_names_out(one_hot_df.columns))
    
    df = pd.concat([df, df_cat], axis=1)
    df.drop(['VEHICLE CLASS', 'TRANSMISSION', 'FUEL TYPE'], axis=1, inplace=True)
    df.dropna(inplace=True)

    return df

@app.route('/predict', methods=['POST'])
def predict():
    data = request.json
    print(data)
    preprocessed_data = preprocess_data(data)
    print(preprocessed_data)
    
    prediction = model.predict(preprocessed_data)[0]
    
    return jsonify({'prediction': prediction})
    

if __name__ == '__main__':
    app.run(debug=True)
