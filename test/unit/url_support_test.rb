require 'test_helper'

class UrlSupportTest < ActionDispatch::IntegrationTest

  extend MiniTest::Expectations
  extend MiniTest::Spec::DSL
  prepend UrlSupport

  let(:params){ {} }
  let :environment do
    Environment.default
  end
  let :request do
    ActionController::TestRequest.new 'HTTP_HOST' => environment.default_hostname
  end

  describe 'override user' do
    it 'preserve override_user if present' do
      params[:override_user] = 1
      assert_equal default_url_options[:override_user], params[:override_user]
    end
  end

  describe '#url_for' do
    let(:controller_path) { 'content_viewer' }

    before do
      @profile = create_user.person
    end

    describe 'target is the origin profile' do

      describe 'profile option is present' do

        describe 'target controller needs profile' do

          describe 'to profile WITH custom domain' do
            before do
              @profile.domains.create name: 'example.com'
              @profile.hostname.must_equal 'example.com'
            end
            let :options do
              url_for profile: @profile.identifier, controller: :profile
            end

            it 'removes the :profile param for the same profile' do
              options[:profile].must_be_nil
            end
          end
        end

        describe 'target controller doesnt need profile' do

          describe 'to profile WITH custom domain' do
            before do
              @profile.hostname.must_be_nil
            end

            it 'removes the :profile param when target' do
              UrlSupport.omit_profile_if_unnecessary = true
              options = url_for profile: @profile.identifier, controller: :account
              options[:profile].wont_equal @profile.identifier
            end
          end
        end

      end

      describe 'profile option isnt present' do

        describe 'target controller needs profile' do
          let :options do
            url_for controller: :content_viewer
          end

          describe 'to profile WITHOUT custom domain' do
            before do
              @profile.hostname.must_be_nil
            end

            it 'add the :profile param' do
              options[:profile].must_equal @profile.identifier
            end
          end
        end
      end
    end

    describe 'target is another profile WITH custom domain' do
      before do
        @other = create_user.person
        @other.domains.create! name: 'other.com'
        @other.hostname.must_equal 'other.com'
      end
      let :options do
        url_for profile: @other.identifier, controller: :profile, host: 'other.com'
      end

      it 'removes the :profile param' do
        options[:profile].must_be_nil
      end
    end

  end

  protected

  ##
  # simpler super method
  #
  def url_for options
    options
  end

end
