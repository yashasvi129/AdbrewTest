# set base image (host OS)
FROM python:3.8

# Use bash instead of sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install basic utilities
RUN apt-get -y update \
    && apt-get install -y curl nano wget nginx git

# Install MongoDB
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add - \
    && echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list \
    && echo "deb http://archive.debian.org/debian stretch main" | tee /etc/apt/sources.list.d/stretch.list \
    && apt-get -o Acquire::Check-Valid-Until=false update \
    && apt-get install -y libssl1.1 mongodb-org yarn

# Install PIP using get-pip.py
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python get-pip.py

# Set environment variables
ENV ENV_TYPE staging
ENV MONGO_HOST mongo
ENV MONGO_PORT 27017
ENV PYTHONPATH=$PYTHONPATH:/src/

# Set the working directory
WORKDIR /src

# Copy dependencies file and install dependencies
COPY src/requirements.txt .
RUN pip install -r requirements.txt

# Copy the rest of the application files
COPY src/ /src/

# Set the command to run your application (adjust as needed)
CMD ["bash", "-c", "cd /src/rest && your-start-command"]
