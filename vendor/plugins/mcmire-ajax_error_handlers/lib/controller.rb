module McMire
  module AjaxErrorHandlers
    module Controller
    protected
      #
      # Catches errors inside an action called via an Ajax.Request request
      # and, if found, loads an error dump in an HTML element with a certain ID using RJS.
      #
      # Two ways to call. If you're not going to return an RJS response, do this:
      #
      #   dumping_errors_to "blah" do
      #     # do something....
      #   end
      #
      # Otherwise, do this:
      #
      #   dumping_errors_to "blah" do |page|
      #     # do something with page
      #   end
      #
      def dumping_errors_to(element_id, &block)
        if block.arity == -1
          # Block is not expecting arguments.
          # Evaluate the block in the context of this controller.
          # The block is responsible for calling render(:update).
          begin
            block.call
          rescue Exception => e
            render :update do |page|
              page.replace_html(element_id, :partial => '/errordump', :locals => { :exception => e })
            end
          end
        else
          # Block is expecting an argument.
          # Wrap block in a render(:update), and evaluate the block in the context of the template.
          # (Here, 'self' refers to the template, not this controller, since the block
          # after render(:update) is +itself+ evaluated in the context of this controller's template.)
          render :update do |page|
            begin
              self.instance_exec(page, &block)
              page.replace_html(element_id, "")
            rescue Exception => e
              page.replace_html(element_id, :partial => '/errordump', :locals => { :exception => e })
            end
          end
        end
      end
      #
      # Similar to above, only catches errors inside an action called via an Ajax.Updater
      # request, and if found, returns an error dump
      #
      def catching_errors
        begin
          yield
        rescue Exception => e
          render :partial => '/errordump', :locals => { :exception => e }
        end
      end
    end
  end
end
