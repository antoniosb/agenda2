require "spec_helper"

describe ServicePolicy do
  subject { ServicePolicy }
  let(:service) { create(:service) }

  context "user with admin role " do
    let(:user) { create(:user) }

    permissions :index?, :show?, :edit?, :update?, :new?, :create?, :destroy? do
      it "allowed" do
        expect(subject).to permit(user, service)
      end
    end
  end

  context "user without admin role " do
    let(:user) { create(:user_not_admin) }

    permissions :index?, :show?, :edit?, :update?, :new?, :create?, :destroy? do
      it "not allowed " do
        expect(subject).not_to permit(user, service)
      end
    end
  end

  context "without any user " do
    let(:user) { nil }

    permissions :index?, :show?, :edit?, :update?, :new?, :create?, :destroy? do
      it "not allowed" do
        expect(subject).not_to permit(user, service)
      end
    end
  end

end