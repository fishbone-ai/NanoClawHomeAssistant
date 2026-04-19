ARG BUILD_FROM=ghcr.io/home-assistant/base:latest                                                                                                                                                    
FROM ${BUILD_FROM}                                                                                                                                                                                   
                                                                                                                                                                                                     
RUN apk add --no-cache \
      git bash docker-cli docker-cli-compose jq curl ttyd \                                                                                                                                          
      nodejs npm \                                                                                                                                                                                   
      python3 make g++ \
      openssh \
 && npm install -g @anthropic-ai/claude-code
                                                                                                                                                                                                     
# SSH: key-only root login on port 2222, no passwords
RUN printf '%s\n' \                                                                                                                                                                                  
      'Port 2222' \                                                                                                                                                                                  
      'PermitRootLogin prohibit-password' \
      'PasswordAuthentication no' \                                                                                                                                                                  
      'AuthorizedKeysFile /data/ssh/authorized_keys' \          
      'StrictModes no' \                                                                                                                                                                             
    > /etc/ssh/sshd_config
                                                                                                                                                                                                     
COPY run.sh /run.sh                                             
RUN chmod +x /run.sh

WORKDIR /share/nanoclaw                                                                                                                                                                              
CMD ["/run.sh"]
