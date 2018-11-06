import random
import numpy as np

class Enviroment:
    def __init__(self):
        self.initial_point = np.zeros(3) #(x,y,alpha)
        self.x=0
        self.y=0
        self.alpha=0
        self.columns=10
        self.rows=2
        self.trayectoria=np.full((self.rows, self.columns), 2) 
        self.trayectoria[0]=np.arange(1,11)
        self.contador=0 #contador para ver cuantas veces se va ejecutando el step
        self.oldX=0
        self.oldY=0 #valores que guardan la posicion anterior
        self.oldDistancia=2
        self.done=false
        self.steps = 500

    def reset(self):
        self.initial_point[0]= 5 #pon o valor fijo que necesites
        self.initial_point[1]= random.randint(0, 1000) #defines el rango que quieras
        self.initial_point[2]= random.uniform(-45,45)
        self.contador=0
        self.oldX=0
        self.oldY=0
        #Tamen se reiniciaria el punto inicial y la posicion anterior

    def step(self, motorR, motorL):
        self.x= motorR
        self.y= motorL
        
        
        
        		"""aqui se opera en funcion de las ecuaciones, simulando la 
                dinámica del coche, y genera un vector de 3 posiciones """
              
              
              
        vector= [7,9,25] #Valores inventados
        
        if (self.contador==1):
            print("primer paso")
            
            """ primer paso del proceso. aqui tratar en el 
            caso de que no haya posicion anterior guardada """
            
        else:
            done = false
            if (self.contador == self.steps):
                done = true
                
            distancia_menor=40 
            
            """Aqui como primer valor poner siempre un numero
            bastante alto, para que cumpla siempre la primera condicion, se 
            comprueba si la distancia va disminuyendo"""
            
            for j in range(self.columns):
                xTrayectoria= self.trayectoria[0][j]
                yTrayectoria= self.trayectoria[1][j]
                distancia_nueva= np.sqrt((xTrayectoria-vector[0])^2 + (yTrayectoria-vector[1])^2) 
                #Calculo el valor de la distancia entre los puntos,revisar
                if (distancia_nueva<distancia_menor):
                    print distancia_nueva
                    distancia_menor=distancia_nueva #guardo nueva distancia como la menor
                    else:
                        done = true
                        break 
                        """ si la distancia no es menor que o que lo que esta guardado,
                        significa que no se va a encontrar un valor mejor, 
                        asi que salimos del bucle """
                        print distancia_menor

				
                """Ahora en función de la distancia, y del angulo, calcular el
                reward"""

e = Enviroment()
e.reset()
e.step(5,3)
