class Cust:
    def __init__(self,x,y,dest):
        self.x = x;
        self.y = y;
        self.dest = dest
        self.step = 0;
    
    def setTransaction(self):
        pass

    def getx(self):
        return (self.x,self.y)

    def getStep(self):
        return self.step

    def move(self):
        self.x += 5
        self.step += 1
        if self.step + 1 >=27:
            self.step = 0

    def stop(self):
        self.step = 0