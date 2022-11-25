# frozen_string_literal: true

# This file is a part of redmine_ishare,
# a issue sharing plugin for Redmine.
#
# Copyright (c) 2022 Bocharov.pw
# https://bocharov.pw

module IshareHelper
  include IssuesHelper
  include AdditionalTagsHelper
  include AttachmentsHelper
  include WatchersHelper
  include QueriesHelper
  include AdditionalTagsHelper

  #include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::FormTagHelper


  def ishare_prepare
    @ishare = {:items => []}
    return if @issue.nil? && params[:id].nil?

    issue_id = @issue.id if !@issue.nil?
    issue_id = params[:id] if @issue.nil? && !params[:id].nil?

    db_result = Ishare.where(:issue_id => issue_id).to_a
    return if db_result.blank?

    ids = Hash.new([])
    db_result.each do |ishare|
      dbg = 0
      ids[ishare.id]= true if  ishare_password_is_expired?(ishare)
      #ids[ishare.id]={ 'isExpired' => ishare_password_is_expired?(ishare) }
    end

    @ishare = {:items => db_result, :expired => ids}
  end


  # Чтобы не прыгать в БД на каждый чих, обсчитаем сразу за один заход.
  def ishare_password_is_expired?(db_row_ishare)
    dt_expired = db_row_ishare.expired

    # Если есть конечное время действия - то проверить протухло или нет
    return false if dt_expired.nil?
    return true if DateTime.now > dt_expired

    return false
  end

  # Вспомогательная пасхалга. чобы генерировались разные картинки при каждой загрузке страницы
  def ishare_random_ava_login
    this_plugin_paths = Rails.root.join("plugins/redmine_ishare/assets/images/ava")
    images = Dir.entries(this_plugin_paths).reject {|f| File.directory? f}
    image = images.sample
    image_tag("/ava/#{image}", alt: "", class: "user-img", :plugin => 'redmine_ishare')
  end


end
