# frozen_string_literal: true

# This file is a part of redmine_ishare,
# a issue sharing plugin for Redmine.
#
# Copyright (c) 2022 Bocharov.pw
# https://bocharov.pw

class Ishare < ActiveRecord::Base
  belongs_to :issue
  belongs_to :user
  #  before_save :generate_timestamp

  # def generate_timestamp
  #   self.expired = DateTime.now
  # end

  # Если прилетел запрос на ввод пароль

  # def self.check_password_igi(params)
  #   return false if params['pass'].nil?
  #   password = params['pass']
  #   commit = params['commit'] # Login
  #   controller = params['controller'] # ishare
  #   action = params['action']   # igi
  #   issue_id = params['id']       # 123
  #
  #   # Ищем в БД
  #   db_result = Ishare.where(:issue_id => issue_id,:password => password )
  #   return false if db_result.blank?
  #
  #   # Далее проверка времени не протухло ли время
  #
  # end


  def self.password_is_expired?(issue_id, password)
    db_result = find_by(:issue_id => issue_id, :password => password)
    dt_expired = db_result.expired

    # Если есть конечное время действия - то проверить протухло или нет
    return false if dt_expired.nil?

    #dt_now = DateTime.now.utc
    # ruby/ rails Умная штука сама приведет типы времени и с равнит кооректно ??
    dt_now = DateTime.now

    return true if dt_now > dt_expired

    return false
  end

end
