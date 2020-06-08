class Book::NonFiction < Book
  validates :category, presence: true
  before_save :flatten_tags

  def flatten_tags
    self.tags = tags.flatten.uniq.sort.reject(&:blank?)
  end

  module Categories
    DATA = {
      "Godsdienst"                 => { fas_icon: "fa-praying-hands"      },
      "Lichaam & Gezondheid"       => { fas_icon: "fa-heartbeat"          },
      "Eten & Drinken"             => { fas_icon: "fa-utensils"           },
      "Huis & Tuin"                => { fas_icon: "fa-home"               },
      "Feest"                      => { fas_icon: "fa-birthday-cake"      },
      "Hobby's"                    => { fas_icon: "fa-cut"                },
      "Sport & Spel"               => { fas_icon: "fa-futbol"             },
      "Beroepen"                   => { fas_icon: "fa-chalkboard-teacher" },
      "Wetenschap & Techniek"      => { fas_icon: "fa-flask"              },
      "Computers & Gamen & Online" => { fas_icon: "fa-desktop"            },
      "Verkeer & Vervoer"          => { fas_icon: "fa-car-side"           },
      "Natuur & Milieu"            => { fas_icon: "fa-tree"               },
      "Dieren"                     => { fas_icon: "fa-paw"                },
      "Landen & Volken"            => { fas_icon: "fa-globe-americas"     },
      "Nederland"                  => { fas_icon: "fa-map-marked-alt"     },
      "Kunst & Cultuur"            => { fas_icon: "fa-palette"            },
      "Theater & Film"             => { fas_icon: "fa-theater-masks"      },
      "Schrijvers & Boeken"        => { fas_icon: "fa-book-reader"        },
      "Muziek"                     => { fas_icon: "fa-music"              },
      "Sprookjes & Volksverhalen"  => { fas_icon: "fa-hat-wizard"         },
      "Gedichten & Versjes"        => { fas_icon: "fa-feather-alt"        },
      "Mens & Maatschappij"        => { fas_icon: "fa-users"              },
    }.freeze

    ALL = DATA.keys.freeze

    def self.fas_icon_for(name)
      DATA.fetch(name, { fas_icon: '' }).fetch(:fas_icon)
    end
  end

  class << self
    def sorted_existing_tags
      pluck(Arel.sql("distinct unnest(tags)"))
    end

    def with_tag(tag)
      where("? = ANY (tags)", tag)
    end
  end
end
