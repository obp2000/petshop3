# Load the rails application
require File.expand_path('../application', __FILE__)

require 'carrierwave/orm/activerecord'
#require 'carrierwave/processing/rmagick'
require 'carrierwave/processing/mini_magick'

CAPTCHA_SALT = "d9caf6a3ad0847d0e05d758e7817dfb5d77f1c141b16530656ada793a26f71dd1"
ContentTag = "content"
SharedPath = "shared"

HeaderImage = "bestic.png"

BackImage = "back1.png"
DeleteImage = "delete.png"
CloseWindowImage = "close.png"

CartImage = "basket.png"
ClearCartImage = "basket_close.png"
AddToCartImage = "basket_add.png"
AddToCartOverImage = "basket_add_over.png"

AddToItemImage = "arrow_large_right.png"

AddHtmlCodeToColourImage = "arrow-180.png"

AllSeasonsImage = "amor.png"
SummerImage = "gadu.png"
WinterImage = "weather-snow.png"

ForumImage = "agt_forum.png"

CloseProcessedOrderImage = "page_table_close.png"

NewForumPostImage = "document-edit.png"
NewProcessedOrderImage = "tick_16.png"
NewItemImage = "newdoc.png"

ChangeCategoryImage = "color_line.png"
ChangeColourImage = "kcoloredit.png"
ChangeSizeImage = "pencil-ruler.png"
ChangePhotoImage = "insert-image.png"

ContactsImage = "contacts.png"
NameImage = "loginmanager.png"
EmailImage = "mail_generic.png"
PhoneImage = "kcall.png"
AddressImage = "kfm_home.png"
ICQImage = "icq_protocol.png"







SaveImageLarge = "document-save.png"
SaveImageSmall = "document-save-16.png"

SearchImage = "search_32.png"

DURATION = 0.5
HIGHLIGHT_DURATION = 2

# Initialize the rails application
Petshop3::Application.initialize!
