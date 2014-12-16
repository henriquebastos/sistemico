class TransactionsController < StateController

  before_action :set_transaction, only: [:approve, :reject]

  respond_to :html, except: [:sitemap]
  respond_to :xml, only: [:sitemap]

  after_action :verify_authorized, except: %i[index sitemap]
  after_action :verify_policy_scoped, only: %i[index sitemap]

  def index
    @transactions = policy_scope(Transaction).order("updated_at DESC")
    # This will instantiate UserDecorator for the users
    @from_users = @transactions.map &:from_user
    @to_users = @transactions.map &:to_user
  end

  def sitemap
    # TODO
  end

  def approve
    transition_state(@transaction, :approve, user_by_permalink_path(@transaction.to_user))
  end

  def reject
    transition_state(@transaction, :reject, user_by_permalink_path(@transaction.to_user))
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

end