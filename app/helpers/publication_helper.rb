  module PublicationHelper
    class Appointments
      def self.publish_on_destroy(channel, appointment)
        PrivatePub.publish_to(channel,
          appointment: appointment.to_json,
          action_name: "destroy")
      end

      def self.publish_on_update(channel, appointment, old_user_id=nil)
        PrivatePub.publish_to( channel, 
        appointment: appointment.to_json, 
        user: appointment.user.to_json,
        service: appointment.service.to_json,
        action_name: "update" )

        if (old_user_id && old_user_id != appointment.user_id)
          update_has_changed_user("/appointments/#{old_user_id}", appointment)
        end

      end

      private
          def self.update_has_changed_user(channel, appointment)
            PrivatePub.publish_to( channel,
              %Q{
                $('tr##{appointment.id}').fadeOut(1000, 'linear', function(){
                  $(this).remove();
                });     
              })
          end
    end
  end