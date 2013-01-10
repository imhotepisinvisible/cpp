require 'json'

class AuditItemsController < ApplicationController
  respond_to :json
  before_filter :require_login

  # GET /audit_items
  # GET /audit_items.json
  def index
    raise unless current_user.is_department_admin?

    start = 7.days.ago.at_midnight.at_beginning_of_day
    stop = Date.today.tomorrow.at_beginning_of_day

    created_events = Event.where("created_at > ? AND created_at < ?", start, stop)
    updated_events = Event.where("updated_at > ? AND updated_at < ?", start, stop)

    created_placements = Placement.where("created_at > ? AND created_at < ?", start, stop)
    updated_placements = Placement.where("updated_at > ? AND updated_at < ?", start, stop)

    created_companies = Company.where("created_at > ? AND created_at < ?", start, stop)
    updated_companies = Company.where("updated_at > ? AND updated_at < ?", start, stop)

    created_students = Student.where("created_at > ? AND created_at < ?", start, stop)

    audits = []
    audits += created_events.map{|i| i.to_audit_item}
    audits += updated_events.map{|i| i.to_audit_item(:updated_at)}
    audits += created_placements.map{|i| i.to_audit_item}
    audits += updated_placements.map{|i| i.to_audit_item(:updated_at)}
    audits += created_companies.map{|i| i.to_audit_item}
    audits += updated_companies.map{|i| i.to_audit_item(:updated_at)}
    audits += created_students.map{|i| i.to_audit_item}

    audits.sort! {|a, b| b.timestamp <=> a.timestamp}
    audits = audits[0..20]
    respond_with audits
  end
end
