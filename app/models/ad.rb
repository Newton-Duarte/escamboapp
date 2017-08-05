class Ad < ActiveRecord::Base

  # Constants

  QUANTITY_PER_PAGE = 9

  # RatyRate gem

  ratyrate_rateable 'quality'

  # Callbacks

  before_save :md_to_html

  # Association

  belongs_to :category, counter_cache: true
  belongs_to :member
  has_many :comments

  # Validates

  validates :title, :description_md, :description_short, :category, presence: true
  validates :picture, :finish_date, presence: true
  validates :price, numericality: { greater_than: 0 }

  # Scopes
  scope :descending_order, ->(page) {
    order(created_at: :desc).page(page).per(QUANTITY_PER_PAGE)
  }

  scope :search, ->(search) {
    where("title LIKE ?", "%#{search}%").page(page).per(QUANTITY_PER_PAGE)
  }

  scope :to_the, ->(member) { where(member: member) }
  scope :by_category, ->(id, page) { where(category: id).page(page).per(QUANTITY_PER_PAGE) }

  # paperclip
  has_attached_file :picture, styles: {
    large: "800x300#",
    medium: "320x150#",
    thumb: "100x100>"
  }, default_url: "images/:style/missing.png"

  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/

  # gem money-rails
  monetize :price_cents

  private

  def md_to_html
    options = {
      flter_html: true,
      link_attributes: {
        rel: "nofollow",
        target: "_blank"
      }
    }

    extensions = {
      space_after_headers: true,
      autolink: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    self.description = markdown.render(self.description_md)

  end
end
