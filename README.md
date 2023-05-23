## Project name: Shops integrator
- This is a json api service integrator for working with multiple stores. 
- The essence of the service is to process bonus points of various stores and their customers.
## Project contains functionality:
- API for CRUD operations on users and stores
- API for viewing bonus user's bonus cards
- API for buying at shops

## Requirements
- ruby 3.1.2
- rails 7
- postgresql

## Services, rvm, bundle
Postgres:
```
brew update
brew install postgres
```
TO use rvm:
```
# Install gpg and rvm
brew install gnupg
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable

# Add rvm to the bash profile then reload
echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"' >> ~/.bash_profile
source ~/.bash_profile

# Install Ruby
rvm install 3.1.2
rvm use 3.1.2 --default
```
Bundle:
```
gem install bundle
bundle install
```

## Create database and migrate schema
- `rails db:create`
- `rails db:migrate`
