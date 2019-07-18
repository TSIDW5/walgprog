FactoryBot.define do
  factory :email_template do
    name { |n| "Name #{n}" }
    subject { |n| "Subject #{n}" }

    content_markdown { write_markdown }
    update_link_title { 'update info' }
    unregister_link_title { 'unregister' }

    trait :with_markdown_variables do
      content_markdown { '@nome @linkAtualizar @linkDesregistrar' }
    end

    trait :welcome do
      content_markdown { '@nome @linkAtualizar @linkDesregistrar' }
      name { I18n.t('email_template.welcome_mail') }
    end

    trait :update_contact do
      content_markdown { '@nome @linkAtualizar @linkDesregistrar' }
      name { I18n.t('email_template.update_contact') }
    end
  end

  def write_markdown
    <<-MARKDOWN.strip_heredoc
        # Effugiam erit cinerem tenuere concurrere
        ## Mihi persequar et trementi muris constant tibique
        Lorem markdownum, abstulerunt preces prima. Ripas et concipit **genuit**.
    MARKDOWN
  end
end
