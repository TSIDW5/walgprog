require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }

    context 'when email' do
      it { is_expected.to allow_value('email@addresse.foo').for(:email) }
      it { is_expected.to allow_value('email@addresse.foo.foo').for(:email) }
      it { is_expected.not_to allow_value('foo').for(:email) }
    end

    context 'when phone' do
      it { is_expected.to allow_value('(11) 3333-4444').for(:phone) }
      it { is_expected.to allow_value('(11) 33333-4444').for(:phone) }
      it { is_expected.not_to allow_value('11 3333-4444').for(:phone) }
      it { is_expected.not_to allow_value('11 33333-4444').for(:phone) }
      it { is_expected.not_to allow_value('113333-4444').for(:phone) }
      it { is_expected.not_to allow_value('1133333-4444').for(:phone) }
      it { is_expected.not_to allow_value('1133334444').for(:phone) }
      it { is_expected.not_to allow_value('11333334444').for(:phone) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:institution) }
  end

  describe 'send email' do
    context 'when contact is created' do
      let(:contact) { create(:contact) }

      it {
        contact.send_welcome_email
        expect { contact.send_welcome_email }.to change {
          ActionMailer::Base.deliveries.count
        }.by(1)
      }
    end

    context 'when contact is updated' do
      let(:contact) { create(:contact) }

      it {
        contact.send_self_update
        expect { contact.send_self_update }.to change {
          ActionMailer::Base.deliveries.count
        }.by(1)
      }
    end

    context 'when contact is updated with succesfuly' do
      let(:contact) { create(:contact) }

      it {
        contact.send_confirmation_update
        expect { contact.send_confirmation_update }.to change {
          ActionMailer::Base.deliveries.count
        }.by(1)
      }
    end
  end

  describe 'testing tokens' do
    context 'with unregistered token' do
      let(:contact) { create(:contact) }

      it {
        contact.generate_token(:unregister_token)
        expect(contact).to be_valid
      }
    end

    context 'with update token' do
      let(:contact) { create(:contact) }

      it {
        contact.generate_token(:update_data_token)
        expect(contact).to be_valid
      }
    end

    context 'with update_by_token_to_unregister' do
      let(:contact) { create(:contact) }

      it {
        params = { id: contact.id, token: contact.unregister_token }

        expect(contact.update_by_token_to_unregister(params)).to eq(:unregistered)
      }
    end

    context 'with update_by_token_to_unregister' do
      let(:contact) { create(:contact) }

      it {
        params = { id: contact.id, token: 'lagarto' }

        expect(contact.update_by_token_to_unregister(params)).to eq(:time_exceeded)
      }
    end

    context 'when update_by_token succesfuly' do
      let(:contact) { create(:contact) }

      it {
        params = { id: contact.id, token: contact.update_data_token }
        params_contact = { id: contact.id, name: contact.name,
                           email: contact.email,
                           institution: contact.institution,
                           unregister_token: contact.unregister_token,
                           update_data_token: contact.update_data_token,
                           update_data_send_at: contact.update_data_send_at,
                           unregistered: contact.unregistered }

        expect(contact.update_by_token(params, params_contact)).to eq('contacts/update_success')
      }
    end

    context 'when update_by_token filds are not valids' do
      let(:contact) { create(:contact) }

      it {
        params = { id: contact.id, token: contact.update_data_token }
        params_contact = { id: contact.id, name: contact.name,
                           email: '',
                           institution: contact.institution,
                           unregister_token: contact.unregister_token,
                           update_data_token: contact.update_data_token,
                           update_data_send_at: contact.update_data_send_at,
                           unregistered: contact.unregistered }

        expect(contact.update_by_token(params, params_contact)).to eq('edit')
      }
    end

    context 'when update_by_token when token are not valids' do
      let(:contact) { create(:contact) }

      it {
        params = { id: contact.id, token: 'lagarto' }
        params_contact = { id: contact.id, name: contact.name,
                           email: contact.email,
                           institution: contact.institution,
                           unregister_token: contact.unregister_token,
                           update_data_token: contact.update_data_token,
                           update_data_send_at: contact.update_data_send_at,
                           unregistered: contact.unregistered }

        expect(contact.update_by_token(params, params_contact)).to eq('contacts/time_exceeded')
      }
    end
  end

  describe 'when exist_email' do
    context 'when exist_email true' do
      let(:contact) { create(:contact) }

      it {
        params_contact = { id: contact.id, name: contact.name,
                           email: contact.email,
                           institution: contact.institution,
                           unregister_token: contact.unregister_token,
                           update_data_token: contact.update_data_token,
                           update_data_send_at: contact.update_data_send_at,
                           unregistered: contact.unregistered }

        expect(contact.exist_email(params_contact)).to eq(true)
      }
    end

    context 'when exist_email false' do
      let(:contact) { create(:contact) }

      it {
        params_contact = { id: contact.id, name: contact.name,
                           email: 'teste@teste.com',
                           institution: contact.institution,
                           unregister_token: contact.unregister_token,
                           update_data_token: contact.update_data_token,
                           update_data_send_at: contact.update_data_send_at,
                           unregistered: contact.unregistered }

        expect(contact.exist_email(params_contact)).to eq(false)
      }
    end
  end
end
