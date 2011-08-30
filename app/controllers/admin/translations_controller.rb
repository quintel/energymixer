class Admin::TranslationsController < AdminController
  set_tab :translations
  before_filter :find_translation, :except => [:index, :new, :create]
  
  def index
    @translations = Translation.all
  end

  def show
  end

  def new
    @translation = Translation.new
  end

  def edit
  end

  def create
    @translation = Translation.new(params[:translation])

    if @translation.save
      redirect_to(admin_translation_path(@translation), :notice => 'Translation was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if @translation.update_attributes(params[:translation])
      redirect_to(admin_translation_path(@translation), :notice => 'Translation was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @translation.destroy
    redirect_to(admin_translations_url, :notice => 'Translation deleted')
  end
  
  protected
  
    def find_translation
      @translation = Translation.find(params[:id])
    end
end
