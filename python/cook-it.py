import os

print()
print('''
--------------------------------------
|           THIS IS COOK-IT           |
|    Build and push Docker images     |
--------------------------------------
''')
print()


path_to = input('Insert the full path to the Dockerfile: ')
name_img = input('Give a name to the new image: ')
tag_img = input('Give a tag to the new image: ')
push_img = input('Do you want to push the image to the registry? (y/n) ')
reg_name = None

if push_img.lower() == 'y':
    reg_name = input('Insert registry and namespace: ')
elif push_img.lower() == 'n':
    pass


print()
os.system(f'echo The path to the file is: {path_to}')
os.system(f'echo The name of the new image will be: {name_img}:{tag_img}')
os.system(f'echo The new image will be pushed to the registry: {reg_name}')
print()


yn = input('Do you want to continue? (y/n) ')


if yn.lower() == 'y':
    os.system('echo Building the image...\n')
    os.system(f'sudo docker build -t {reg_name}/{name_img}:{tag_img} {path_to}')
    
    if push_img.lower() == 'y':
        os.system('echo Pushing the image...\n')
        os.system(f'sudo docker push {reg_name}/{name_img}:{tag_img}')

elif yn.lower() == 'n':
    print('Bye!\n')
    quit()
else:
    print("Only 'y/n'!")

