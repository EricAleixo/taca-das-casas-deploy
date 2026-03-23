class CasasController < ApplicationController
  before_action :set_casa, only: %i[show edit update destroy] # Removido o :adicionar_pontos

  # GET /casas or /casas.json
  def index
    @casas = Casa.all
  end

  # GET /casas/1 or /casas/1.json

  def show
  @casa = Casa.find(params[:id])
  @alunos = Aluno.where(casa_id: @casa.id)

  respond_to do |format|
    format.html
    format.xlsx
  end
end

  def alunosPorCasa
    @alunosPorCasa = Aluno.all
  end

  # GET /casas/new
  def new
    @casa = Casa.new
  end

  # GET /casas/1/edit
  def edit
  end

  # POST /casas or /casas.json
  def create
    @casa = Casa.new(casa_params)

    respond_to do |format|
      if @casa.save
        format.html { redirect_to @casa, notice: "Casa criada com sucesso." }
        format.json { render :show, status: :created, location: @casa }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @casa.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /casas/1 or /casas/1.json
  def update
    respond_to do |format|
      if @casa.update(casa_params)
        format.html { redirect_to @casa, notice: "Casa atualizada com sucesso." }
        format.json { render :show, status: :ok, location: @casa }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @casa.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /casas/1 or /casas/1.json
  def destroy
    @casa.destroy!

    respond_to do |format|
      format.html { redirect_to casas_path, status: :see_other, notice: "Casa excluída com sucesso." }
      format.json { head :no_content }
    end
  end

  def atribuicao_pontual_especial
    @casas = Casa.all || []
  end


  # POST /casas/adicionar_pontos
def adicionar_pontos
  if params[:casa_id].present?
    @casa = Casa.find_by(id: params[:casa_id])

    if @casa
      pontos = params[:pontos].to_i

      if pontos != 0
        @casa.increment!(:pontos, pontos)
        acao = pontos.positive? ? "adicionados" : "removidos"
        redirect_to atribuicao_pontual_especial_casas_path, notice: "#{pontos.abs} pontos #{acao} com sucesso da casa #{@casa.nome}!"
      else
        redirect_to atribuicao_pontual_especial_casas_path, alert: "Por favor, insira um valor de pontos diferente de zero."
      end
    else
      redirect_to atribuicao_pontual_especial_casas_path, alert: "Casa não encontrada."
    end
  else
    redirect_to atribuicao_pontual_especial_casas_path, alert: "Por favor, selecione uma casa."
  end
end






  private

    # Use callbacks to share common setup or constraints between actions.
    def set_casa
      @casa = Casa.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def casa_params
      params.require(:casa).permit(:nome, :pontos)
    end
end
