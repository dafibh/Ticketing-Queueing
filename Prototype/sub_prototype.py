class Cust:
	def __init__(self, name):
		self.name = name

class Employee:
	def __init__(self):
		self.custs = []


custo = []
employ = Employee()
x = ''

while x == '':
	nama = input('name: ')
	custo.append(Cust(nama))
	x = input('more?: ')

for cust in custo:
	print(f'cust add: {cust.name}')
	employ.custs.append(cust)

for cust in custo:
	cust.name = "changed"
	print(f'cust change main: {cust.name}')
custo[0].close()
for x in employ.custs:
	print(f'cust change in: {x.name}')