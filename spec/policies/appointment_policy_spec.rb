require "spec_helper"

describe AppointmentPolicy do
  subject { AppointmentPolicy }
  let(:appointment) { create(:appointment) }

  context "without any user" do
    let(:user) { nil }

    permissions :index?, :show?, :edit?, :update?, :new?, :create?, :destroy? do
      it "ensures a user must exist with exception" do
        expect { AppointmentPolicy.new(user, appointment) }.to raise_error Pundit::NotAuthorizedError, "must be logged in"
      end
    end
  end

  context "user with admin role " do
    let(:user) { create(:user) }

    permissions :index?, :new?, :show?, :create?, :edit?, :update?, :destroy? do
      it "allowed" do
        expect(subject).to permit(user, appointment)
      end
    end
  end

  context "user without admin role " do
    let(:user) { create(:user_not_admin) }

    permissions :index?, :new? do
      it "allowed" do
        expect(subject).to permit(user, appointment)
      end
    end

    permissions :show?, :create? do
      context "when the appointment belongs to the user " do
        let(:user) { appointment.user }
        it "is allowed" do
          expect(subject).to permit(user, appointment)
        end
      end

      context "when the appointment doesn't belong to the user " do
        it "is not allowed" do
          expect(subject).not_to permit(user, appointment)
        end
      end
    end

    permissions :destroy? do
      context "when the appointment belongs to the user " do
        let(:user) { appointment.user }
        context "and the appointment is not in 'concluded' status " do
          it "allowed" do
            expect(subject).to permit(user, appointment)
          end
        end
        context "and the appointment is at 'concluded' status " do
          it "is allowed" do
            appointment.status = 'concluded'
            expect(subject).to permit(user, appointment)
          end
        end
      end

      context "when the appointment does not belong to the user" do
        it "not allowed" do
          expect(subject).not_to permit(user, appointment)
        end
      end
    end

    permissions :edit?, :update? do
      it "is allowed" do
        expect(subject).to permit(user, appointment)
      end
    end
  end
end