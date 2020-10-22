import pygame
from customer import Cust
from datetime import datetime, timedelta

pygame.init()
clock = pygame.time.Clock()
win = pygame.display.set_mode((500,480))
pygame.display.set_caption("Pygame Test")


""" Set Images """
walkRight = []
walkRight.append(pygame.image.load('Images/R1.png'))
walkRight.append(pygame.image.load('Images/R2.png'))
walkRight.append(pygame.image.load('Images/R3.png'))
walkRight.append(pygame.image.load('Images/R4.png'))
walkRight.append(pygame.image.load('Images/R5.png'))
walkRight.append(pygame.image.load('Images/R6.png'))
walkRight.append(pygame.image.load('Images/R7.png'))
walkRight.append(pygame.image.load('Images/R8.png'))
walkRight.append(pygame.image.load('Images/R9.png'))
bg = pygame.image.load('Images/bg.jpg')
char = pygame.image.load('Images/standing.png')
'''set Images end '''



""" Import CSV """
transaction = []
lines = []

def readList():
    file = open('transactions.csv', 'r') #transactions.csv
    contents = file.readlines()
    file.close()

    contents = [line.strip() for line in contents[0:]]
    for line in contents:
        records = {
            "tid": "",
            "datetime": "",
            "custid": "",

        }

        data = line.split(',')
        records["tid"] = data[0]
        records["datetime"] = data[1]
        records["custid"] = data[3]
        
        transaction.append(records)


    file = open('transactionlines.csv', 'r') #transactionslines.csv
    contents = file.readlines()
    file.close()

    contents = [line.strip() for line in contents[0:]]
    for line in contents:
        records = {
            "lid": "",
            "datetime": "",
            "quantity": "",
            "item": "",
            "price": "",

        }

        data = line.split(',')
        records["lid"] = data[0]
        records["datetime"] = data[2]
        records["quantity"] = data[3]
        records["item"] = data[4]
        records["price"] = data[5]
        
        lines.append(records)

    #for i in lines:
        #print(i)

readList()
""" Import csv end """



""" Set Sim Time """
start_time = datetime(2020, 7, 20, 8, 00) #set time

def addTime(): #add time function
    return start_time + timedelta(minutes=5)

def timestr(): #get time str
    timestring = str(start_time.strftime('%m/%d/%Y %I:%M %p'))

    if timestring[0] == "0":
        timestring = timestring[1:]
    return timestring
""" End Set Time """



"""
Test multiple

"""
finish = [0,0,0,0]
rows = [0,64,128,192,256,320]

q1 = []
q2 = []

customer = []
customer.append(Cust(-140,rows[2],256))
customer.append(Cust(-300,rows[4],320))
customer.append(Cust(-800,rows[4],256))
customer.append(Cust(-40,rows[2],320))

"""
End Test multiple
"""



def redrawGameWindow(): #draw to screen
    
    win.blit(bg, (0,0))  

    checker = 0
    for cust in customer:
        if cust.x <= cust.dest:
            cust.move()
            win.blit(walkRight[cust.getStep()//3], (cust.x,cust.y))
        else:
            if finish[checker] == 1:
                cust.move()
                win.blit(walkRight[cust.getStep()//3], (cust.x,cust.y))
            else:
                win.blit(char, (cust.x, cust.y))

        checker = checker + 1
    pygame.display.update() 



'''temp variables'''
start = 0    
seconds = 0



'''end temp variables'''



print(f"time: {timestr()}")
run = True
while run:
    clock.tick(30)
    current_time = pygame.time.get_ticks() 

    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            run = False

    keys = pygame.key.get_pressed()

    if keys[pygame.K_KP1]:
        finish[0] = 1
    if keys[pygame.K_KP2]:
        finish[1] = 1
    if keys[pygame.K_KP3]:
        finish[2] = 1
    if keys[pygame.K_KP4]:
        finish[3] = 1
    if keys[pygame.K_KP5]:
        for i in finish:
            print(i)

    if current_time <100:
        start = current_time

    if current_time - start >1000:
        start = current_time
        seconds = seconds + 1
        """print(seconds)"""
        start_time=addTime()
        print(f"time: {timestr()}")

    redrawGameWindow() 
    
    

pygame.quit()
