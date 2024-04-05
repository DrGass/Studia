import os
from dotenv import load_dotenv
import time
import paramiko




def main():
    # credentials

    # dotenv when using USERNAME keyword instead of USER takes Your username from local machine instead of .env file
    load_dotenv()
    host = str(os.getenv('HOST'))
    username = str(os.getenv('USER'))
    password = str(os.getenv('PASSWORD'))


    # make a ssh connection
    client = paramiko.client.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(host, username=username, password=password)
    
    # make a sftp connection
    sftp = client.open_sftp()
    remoteArtifactPath = './Filmy/'
    filesInRemoteArtifact = sftp.listdir(path = remoteArtifactPath)
    for file in filesInRemoteArtifact:
        try:
            sftp.remove(remoteArtifactPath + file)
        except:
            print("no such file")

    filmList = os.listdir("D:\Pobrane\Filmy\\")

    for film in filmList:
        try:
            f = open(f"{film}.txt","x")
            sftp.file(f'{remoteArtifactPath + film}','a', -1)
            f.close()
        except:
            print("File already exists")
        

    client.close()

    time.sleep(5)
    for film in filmList:
        try:
            os.remove(f"{film}.txt")
        except:
            print("File already doesn't exist")


if __name__ == "__main__":
    main()