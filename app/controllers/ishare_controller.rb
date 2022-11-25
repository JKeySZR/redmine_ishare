# frozen_string_literal: true

# This file is a part of redmine_ishare,
# a issue sharing plugin for Redmine.
#
# Copyright (c) 2022 Bocharov.pw
# https://bocharov.pw

require 'securerandom'

class IshareController < ApplicationController
  #layout 'admin'
  # Вырубить нахер меню
  self.main_menu = false

  helper :journals
  helper :attachments
  attr_accessor :id

  before_action :check_if_password_required, :only => [:showissue]
  #before_action :check_if_password_required

  def showissue
    issue_id = params[:id]
    @issue = Issue.find(issue_id)

    # Спижзео в  issues_controller
    @relations =
      @issue.relations.
        select do |r|
        r.other_issue(@issue) && r.other_issue(@issue).visible?
      end
    @journals = @issue.visible_journals_with_index
    @journals.reverse!

    @allowed_statuses = @issue.new_statuses_allowed_to(User.current)
    @priorities = IssuePriority.active
    @time_entry = TimeEntry.new(:issue => @issue, :project => @issue.project)
    @time_entries = @issue.time_entries.visible.preload(:activity, :user)
    @relation = IssueRelation.new

    render :template => 'issues/show'
    #render :template => 'ishare/show'

  end

  def index
    dbg = 0
  end


  # Если прилетел запрос на ввод пароль
  def check_password_igi

    return false if params['pass'].nil?

    password = params['pass']
    #commit = params['commit'] # Login
    #controller = params[:controller] # ishare
    #action = params[:action]  # igi
    issue_id = params[:id] # 123

    # 1. Ищем в БД
    db_result = Ishare.find_by(:issue_id => issue_id, :password => password)
    return false if db_result.blank?

    # 2. Далее проверка времени не протухло ли время
    cnt_igi = db_result.cnt_igi + 1
    Ishare.where(['id = ?', db_result.id]).update_all(:cnt_igi => cnt_igi)

    return false if  Ishare.password_is_expired?(issue_id,password)

    # 3. Если все корректно тогда запилиь в переменну. сессию
    # session[:ishare]={'container_id' => issue_id.to_i}
    if session[:ishare].nil?
      session[:ishare] = Hash.new([])
    end
    session[:ishare][issue_id] = { 'container_id' => issue_id.to_i, 'passed' => true }

    return true
  end

  # Это вызвается вначале всегда. перед вызовом мтода метода showissue  ishare/:id
  # если пароль не был введен , то шлем на форму ввода пароля
  def check_if_password_required
    issue_id = params[:id]

    # 1. Мы попали сюда с формы ввода пароля ?
    if request.post? && !params['action'].nil? && params['action'] == 'igi'
      return false if check_password_igi
    end

    # 2. Мы попали сюда потому что хотим глянуть таск ?
    if !params['action'].nil? && params['action'] == 'showissue'
      # 2.1  Тогда надо проверить в сесси а вводили ли мы уже пароль ? если да тогда пароль не нужен
      if !session[:ishare].nil? && session[:ishare].key?(issue_id)
        return false if !session[:ishare][issue_id]['passed'].nil?
      end
    end

    # 3. Ситуация неведома нахер с пляжа, вводить пароль

    # head :unauthorized
    # @link https://stackoverflow.com/questions/2075645/rails-return-a-401
    #render :partial => 'ishare/password_form', :status => :unauthorized
    render :template => 'ishare/password_form2', :status => :unauthorized
    #render :template => "ishare/password_form2", :formats => [:html], :layout => false, :status => :unauthorized

  end

  def destroy
    ids = params[:ishare_ids]
    issue_id = params[:id]
    Ishare.where(id:ids).destroy_all
    cnt_chared = Ishare.where("issue_id = ?" , issue_id).all.count
    respond_to do |format|
      format.js {
        render inline: "$('#ishare__badge_#{issue_id}').text(#{cnt_chared});"
      }
    end

  end

  # Пишем в  БД  в таблицу ishares какой таск какой пароль.
  def create
    return if !params[:ishare]
    if params[:delete]
      destroy
      return
    end
    user = User.current
    password = params[:ishare][:pass]

    return if password.blank?

    note = params[:ishare][:note]
    issue_id = params[:id]
    dt_exp_date = params[:ishare][:experied][:date]
    dt_exp_time = params[:ishare][:experied][:time]

    # Если не указан день, но указано время - значит берем текущий день.
    if dt_exp_date.blank? && !dt_exp_time.blank?
      # !!Локальное время пользователя
      dt = DateTime.current.to_date.to_s + ' ' + dt_exp_time
      dt_exp_0 = dt.to_time(User.current.time_zone)
      dt_exp = dt_exp_0.utc.strftime("%Y-%m-%d %H:%M:%S")
    end

    if !dt_exp_date.blank? && !dt_exp_time.blank?
      dt = "#{dt_exp_date} #{dt_exp_time}"
      dt_exp = dt.to_time(User.current.time_zone).utc.strftime("%Y-%m-%d %H:%M:%S")
    end

    db_result = Ishare.create(:issue_id => issue_id,
                              :user_id => User.current.id,
                              :password => password,
                              :expired => dt_exp,
                              :note => note)
    cnt_chared = Ishare.where(:issue_id => issue_id).all.count

    respond_to do |format|
      format.html do
        # redirect_to_referer_or do
        #   render(:html => 'Watcher added.', :status => 200, :layout => true)
        # end
      end
      #format.js  {head 200}
      format.js {
        render inline: "$('#ishare__badge_#{issue_id}').text(#{cnt_chared});"
      }
      format.api { render_api_ok }
    end

  end

  # I`m Go IN
  # Это пользователь ввел пароль , надо его проверить и пустить его дальше или нет.
  def igi
    check_password_igi
    redirect_to ishare_show_path
  end

end
