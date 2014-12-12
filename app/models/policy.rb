class Policy < ActiveRecord::Base

    METHODS = ['SWORD', 'HARVEST', 'INDIVIDUAL_DOWNLOAD',
               'RECRUIT_FROM_AUTHOR_MANUSCRIPT']

    PRINTS = ['PREPRINT', 'POSTPRINT', 'FINALPRINT'];

    validates :method_of_acquisition, inclusion: { in: METHODS },
              allow_blank: true

    validates :print_version, inclusion: { in: PRINTS },
              allow_blank: true

    belongs_to :policyable, :polymorphic => true

end
