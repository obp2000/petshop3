# Load the rails application
require File.expand_path('../application', __FILE__)

require 'carrierwave/orm/activerecord'
#require 'carrierwave/processing/rmagick'
require 'carrierwave/processing/mini_magick'

CAPTCHA_SALT = "d9caf6a3ad0847d0e05d758e7817dfb5d77f1c141b16530656ada793a26f71dd1"
ContentTag = "content"
SharedPath = "shared"

# Initialize the rails application
Petshop3::Application.initialize!
