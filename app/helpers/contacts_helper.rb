module ContactsHelper

  def merge_subdivision_contacts(contacts)
    contacts = contacts.to_hash
    result = { 'subdivision_contacts' => [] }

    contacts['subdivision_contacts'].each do |contact|
      different = true
      result['subdivision_contacts'].each do |result_contact|
        if result_contact['building']['address'] == contact['building']['address'] &&
          result_contact['working_hours'] == contact['working_hours']
          result_contact['additional_contacts'] = result_contact['additional_contacts'] | contact['additional_contacts']
          result_contact['office'] = [result_contact['office']] if result_contact['office'].is_a? String
          result_contact['office'].push contact['office'] if result_contact['office'].is_a? Array
          result_contact['emails'] = result_contact['emails'] | contact['emails']
          result_contact['phones'] = result_contact['phones'] | contact['phones']
          different = false
        end
      end
      result['subdivision_contacts'].push contact if different
    end

    Hashie::Mash.new(result)
  end

end
