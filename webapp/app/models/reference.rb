class Reference < ApplicationRecord
  belongs_to :user

  def self.sanitise_url(str)
    unless (/^(https?\:)?\/\// =~ str)
      str = "http://" << str
    end
  end

  def self.valid_url(str)
    allowed_chars = "[-A-Za-z0-9@:%._\+~#=?&//=]"
    return /^(https?:)?\/\/#{allowed_chars}{2,256}\.[a-z]+\b(#{allowed_chars}*)?/ =~ str
  end
end
