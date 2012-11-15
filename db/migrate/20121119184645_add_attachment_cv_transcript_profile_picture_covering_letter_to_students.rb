class AddAttachmentCvTranscriptProfilePictureCoveringLetterToStudents < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.has_attached_file :cv
      t.has_attached_file :transcript
      t.has_attached_file :profile_picture
      t.has_attached_file :covering_letter
    end
  end

  def self.down
    drop_attached_file :users, :cv
    drop_attached_file :users, :transcript
    drop_attached_file :users, :profile_picture
    drop_attached_file :users, :covering_letter
  end
end
