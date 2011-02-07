# coding: utf-8
class Admin::BaseController < ApplicationController
  before_filter :login_required
end

