library(rmarkdown)
library(distill)
library(postcards)

system("cd ~/motionlab-site; git pull")
Sys.sleep(15)

rmarkdown::render_site()

Sys.sleep(30)
system("cd ~/motionlab-site; git add *")
system("cd ~/motionlab-site; git commit -m 'Update motionlab site.'")
system("cd ~/motionlab-site; git push origin main")


