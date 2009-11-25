# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_medvane3_session',
  :secret      => '26e24817f732fb2951b0757b2c0534a1570b9da75897dcbfbd70476edaf9b87d8626730a05ba32de54798049ff24e82cb8da03d8f6f1d8a21d91ad22ef3adf7d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
