import  numpy as np

class generator():
    def generate_csv(self,data):
        datos = np.asarray(data)
        np.savetxt("uvispace/uvinavigator/controllers/linefollowers/neural_controller/resources/validation_csv/differential_final.csv",  # Archivo de salida
                   datos.T,  # Trasponemos los datos
                   fmt="%f",  # Usamos números enteros
                   delimiter=";")  # Para que sea un CSV de verdad
