import os
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, KeepTogether, HRFlowable
)
from reportlab.pdfgen import canvas

class NumberedCanvas(canvas.Canvas):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._saved_page_states = []

    def showPage(self):
        self._saved_page_states.append(dict(self.__dict__))
        self._startPage()

    def save(self):
        num_pages = len(self._saved_page_states)
        for state in self._saved_page_states:
            self.__dict__.update(state)
            self.draw_page_number(num_pages)
            super().showPage()
        super().save()

    def draw_page_number(self, page_count):
        self.saveState()
        self.setFont("Helvetica", 8)
        self.setFillColor(colors.HexColor("#64748b"))
        # Rodapé
        self.setStrokeColor(colors.HexColor("#e2e8f0"))
        self.setLineWidth(0.5)
        self.line(40, 35, 555, 35)
        self.drawString(40, 24, "Editor de Documentos Flutter — Relatório Técnico de Migração Arquitetural (MVVM)")
        page_text = f"Página {self._pageNumber} de {page_count}"
        self.drawRightString(555, 24, page_text)
        self.restoreState()

def gerar_relatorio_pdf(caminho_saida):
    doc = SimpleDocTemplate(
        caminho_saida,
        pagesize=A4,
        leftMargin=36,
        rightMargin=36,
        topMargin=36,
        bottomMargin=46
    )

    styles = getSampleStyleSheet()

    # Estilos customizados
    badge_style = ParagraphStyle(
        'Badge',
        fontName='Helvetica-Bold',
        fontSize=8,
        leading=10,
        textColor=colors.HexColor('#1d4ed8')
    )

    title_style = ParagraphStyle(
        'MainTitle',
        fontName='Helvetica-Bold',
        fontSize=16,
        leading=20,
        textColor=colors.HexColor('#0f172a'),
        spaceAfter=6
    )

    meta_style = ParagraphStyle(
        'MetaText',
        fontName='Helvetica',
        fontSize=8.5,
        leading=12,
        textColor=colors.HexColor('#475569')
    )

    h1_style = ParagraphStyle(
        'Heading1_Custom',
        fontName='Helvetica-Bold',
        fontSize=12,
        leading=15,
        textColor=colors.HexColor('#1e3a8a'),
        spaceBefore=12,
        spaceAfter=6
    )

    h2_style = ParagraphStyle(
        'Heading2_Custom',
        fontName='Helvetica-Bold',
        fontSize=10,
        leading=13,
        textColor=colors.HexColor('#0f172a'),
        spaceBefore=8,
        spaceAfter=4
    )

    body_style = ParagraphStyle(
        'Body_Custom',
        fontName='Helvetica',
        fontSize=8.5,
        leading=12,
        textColor=colors.HexColor('#1e293b'),
        spaceAfter=5
    )

    body_bold = ParagraphStyle(
        'Body_Bold',
        fontName='Helvetica-Bold',
        fontSize=8.5,
        leading=12,
        textColor=colors.HexColor('#1e293b')
    )

    box_style = ParagraphStyle(
        'BoxText',
        fontName='Helvetica',
        fontSize=8.5,
        leading=12,
        textColor=colors.HexColor('#1e3a8a')
    )

    th_style = ParagraphStyle(
        'TableHeader',
        fontName='Helvetica-Bold',
        fontSize=8,
        leading=10,
        textColor=colors.HexColor('#0f172a')
    )

    td_style = ParagraphStyle(
        'TableCell',
        fontName='Helvetica',
        fontSize=7.5,
        leading=9.5,
        textColor=colors.HexColor('#1e293b')
    )

    code_block = ParagraphStyle(
        'CodeBlock',
        fontName='Courier',
        fontSize=7.5,
        leading=9.5,
        textColor=colors.HexColor('#0f172a'),
        backColor=colors.HexColor('#f1f5f9'),
        borderColor=colors.HexColor('#cbd5e1'),
        borderWidth=0.5,
        borderPadding=6,
        spaceBefore=4,
        spaceAfter=6
    )

    story = []

    # Cabeçalho
    story.append(Paragraph("RELATÓRIO TÉCNICO OBRIGATÓRIO — FASE 1", badge_style))
    story.append(Paragraph("Migração Arquitetural para MVVM em Flutter", title_style))
    story.append(HRFlowable(width="100%", thickness=1.5, color=colors.HexColor("#2563eb"), spaceAfter=8))

    meta_table_data = [
        [
            Paragraph("<b>Projeto:</b> Editor de Documentos (edit_doc_flutter)", meta_style),
            Paragraph("<b>Ambiente:</b> Linux Container / Flutter SDK / Codespaces", meta_style),
        ],
        [
            Paragraph("<b>Padrão Arquitetural:</b> Model-View-ViewModel (MVVM)", meta_style),
            Paragraph("<b>Status:</b> Migração Concluída com Sucesso", meta_style),
        ]
    ]
    meta_table = Table(meta_table_data, colWidths=[270, 250])
    meta_table.setStyle(TableStyle([
        ('VALIGN', (0, 0), (-1, -1), 'TOP'),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 2),
        ('TOPPADDING', (0, 0), (-1, -1), 2),
        ('LEFTPADDING', (0, 0), (-1, -1), 0),
        ('RIGHTPADDING', (0, 0), (-1, -1), 0),
    ]))
    story.append(meta_table)
    story.append(Spacer(1, 8))

    # Box de resumo
    resumo_box = Table(
        [[Paragraph("<b>Resumo:</b> O código monolítico original do DartPad (contendo 3 telas em um único arquivo com setState direto) foi migrado e estruturado em camadas independentes (Model, View, ViewModel e Utils) no Flutter, garantindo reatividade nativa com ChangeNotifier e ListenableBuilder, rotas nomeadas e total separação de responsabilidades.", box_style)]],
        colWidths=[520]
    )
    resumo_box.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, -1), colors.HexColor('#eff6ff')),
        ('BOX', (0, 0), (-1, -1), 1, colors.HexColor('#3b82f6')),
        ('TOPPADDING', (0, 0), (-1, -1), 6),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
        ('LEFTPADDING', (0, 0), (-1, -1), 8),
        ('RIGHTPADDING', (0, 0), (-1, -1), 8),
    ]))
    story.append(resumo_box)
    story.append(Spacer(1, 10))

    # 1. Mapeamento
    story.append(Paragraph("1. Mapeamento de Classes e Widgets", h1_style))
    story.append(Paragraph("Mapeamento completo dos componentes monolíticos do DartPad para a nova árvore estrutural MVVM:", body_style))

    mapping_data = [
        [
            Paragraph("Elemento Original (DartPad)", th_style),
            Paragraph("Novo Caminho no Projeto", th_style),
            Paragraph("Camada", th_style),
            Paragraph("Responsabilidade e Papel", th_style)
        ],
        [
            Paragraph("class Usuario", td_style),
            Paragraph("lib/models/usuario.dart", td_style),
            Paragraph("<b>Model</b>", td_style),
            Paragraph("Entidade de domínio do usuário com métodos de serialização (toMap/fromMap) e copyWith.", td_style)
        ],
        [
            Paragraph("class Documento", td_style),
            Paragraph("lib/models/documento.dart", td_style),
            Paragraph("<b>Model</b>", td_style),
            Paragraph("Entidade de domínio de documentos (id, titulo, conteudo, dataModificacao, autorEmail).", td_style)
        ],
        [
            Paragraph("Preferências / Tema", td_style),
            Paragraph("lib/models/services/preferences_service.dart", td_style),
            Paragraph("<b>Model (Service)</b>", td_style),
            Paragraph("Persistência local de preferências de tema e usuário ativo usando shared_preferences.", td_style)
        ],
        [
            Paragraph("Mocks / Banco em memória", td_style),
            Paragraph("lib/models/services/banco_local_service.dart", td_style),
            Paragraph("<b>Model (Service)</b>", td_style),
            Paragraph("Serviço de persistência com operações CRUD assíncronas para usuários e documentos.", td_style)
        ],
        [
            Paragraph("Funções de validação", td_style),
            Paragraph("lib/utils/validadores.dart", td_style),
            Paragraph("<b>Utils</b>", td_style),
            Paragraph("Funções estáticas reutilizáveis para validação de Nome, E-mail, Senha e Título.", td_style)
        ],
        [
            Paragraph("Lógica de Login/Sessão", td_style),
            Paragraph("lib/viewmodels/auth_viewmodel.dart", td_style),
            Paragraph("<b>ViewModel</b>", td_style),
            Paragraph("Regras de negócio de autenticação, cadastro e tema herdando de ChangeNotifier.", td_style)
        ],
        [
            Paragraph("Lógica de Documentos", td_style),
            Paragraph("lib/viewmodels/documentos_viewmodel.dart", td_style),
            Paragraph("<b>ViewModel</b>", td_style),
            Paragraph("Estado reativo da listagem e operações de salvar/excluir documentos (ChangeNotifier).", td_style)
        ],
        [
            Paragraph("Tela de Login", td_style),
            Paragraph("lib/views/login_view.dart", td_style),
            Paragraph("<b>View</b>", td_style),
            Paragraph("Rota '/': Interface de autenticação desacoplada. Escuta AuthViewModel via ListenableBuilder.", td_style)
        ],
        [
            Paragraph("Tela de Cadastro", td_style),
            Paragraph("lib/views/cadastro_view.dart", td_style),
            Paragraph("<b>View</b>", td_style),
            Paragraph("Rota '/cadastro': Interface de cadastro de novos usuários com validações em tempo real.", td_style)
        ],
        [
            Paragraph("Tela Home (Lista)", td_style),
            Paragraph("lib/views/home_view.dart", td_style),
            Paragraph("<b>View</b>", td_style),
            Paragraph("Rota '/home': Listagem reativa de documentos, alternador de tema e diálogo de logout.", td_style)
        ],
        [
            Paragraph("Tela Editor", td_style),
            Paragraph("lib/views/editor_view.dart", td_style),
            Paragraph("<b>View</b>", td_style),
            Paragraph("Rota '/editor': Interface unificada para criação e edição com salvamento reativo.", td_style)
        ],
        [
            Paragraph("main() e MaterialApp", td_style),
            Paragraph("lib/main.dart", td_style),
            Paragraph("<b>Entry Point</b>", td_style),
            Paragraph("Inicialização assíncrona, injeção de dependências, tema dinâmico e rotas nomeadas.", td_style)
        ],
    ]

    table_mapping = Table(mapping_data, colWidths=[110, 155, 65, 190])
    table_mapping.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#f1f5f9')),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.HexColor('#cbd5e1')),
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('TOPPADDING', (0, 0), (-1, -1), 3),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 3),
        ('LEFTPADDING', (0, 0), (-1, -1), 4),
        ('RIGHTPADDING', (0, 0), (-1, -1), 4),
    ]))
    story.append(table_mapping)

    story.append(PageBreak())

    # 2. Alterações de Estrutura e Imports
    story.append(Paragraph("2. Alterações de Estrutura e Imports", h1_style))
    story.append(Paragraph("A quebra do código único em arquivos isolados exigiu adaptações estruturais chave:", body_style))

    story.append(Paragraph("<b>2.1. Organização de Imports e Direção das Dependências</b>", h2_style))
    story.append(Paragraph("No DartPad não existiam imports. Na nova arquitetura, as dependências são unidirecionais: as <i>Views</i> importam apenas ViewModels e Utils; os <i>ViewModels</i> importam apenas Models/Services e o Flutter Foundation; e os <i>Models</i> são totalmente independentes de qualquer elemento gráfico ou framework visual.", body_style))

    story.append(Paragraph("<b>2.2. Encapsulamento e Visibilidade de Atributos</b>", h2_style))
    story.append(Paragraph("Variáveis que antes eram globais ou mutáveis diretamente na UI foram privatizadas nos ViewModels com o prefixo '_' (ex: <code>_usuarioAtual</code>, <code>_documentos</code>, <code>_isLoading</code>, <code>_isDarkTheme</code>). O acesso pelas Views é realizado exclusivamente via <i>getters</i> públicos imutáveis, impedindo mutações indevidas do estado fora do ViewModel.", body_style))

    story.append(Paragraph("<b>2.3. Injeção de Dependências e Criação de Construtores</b>", h2_style))
    story.append(Paragraph("Instâncias globais foram eliminadas em prol de injeção explícita via construtor nos ViewModels (ex: <code>AuthViewModel({required BancoLocalService bancoService, ...})</code>) e nas Views (ex: <code>LoginView({required AuthViewModel authViewModel})</code>), garantindo alta testabilidade e baixo acoplamento.", body_style))

    story.append(Paragraph("<b>2.4. Centralização de Rotas Nomeadas</b>", h2_style))
    story.append(Paragraph("Chamadas duras com <code>Navigator.push(MaterialPageRoute(...))</code> foram substituídas pelo mapa declarativo de rotas nomeadas no <code>lib/main.dart</code> (<code>'/'</code>, <code>'/cadastro'</code>, <code>'/home'</code> e <code>'/editor'</code>), permitindo navegação desacoplada via <code>Navigator.pushNamed</code> e <code>pushReplacementNamed</code>.", body_style))

    # 3. Mudanças no Gerenciamento de Estado
    story.append(Spacer(1, 4))
    story.append(Paragraph("3. Mudanças no Gerenciamento de Estado", h1_style))

    story.append(Paragraph("<b>3.1. Eliminação do setState() para Regras de Negócio</b>", h2_style))
    story.append(Paragraph("No modelo original, as telas executavam funções assíncronas e manipulavam o estado chamando <code>setState(() { ... })</code>. Com o MVVM, toda regra de negócio foi transferida para os ViewModels. O uso de <code>setState()</code> nas Views foi estritamente restrito a estados efêmeros de apresentação visual (como alternar <code>_senhaOculta</code>).", body_style))

    story.append(Paragraph("<b>3.2. Padrão Observador com ChangeNotifier e notifyListeners()</b>", h2_style))
    story.append(Paragraph("Os ViewModels estendem <code>ChangeNotifier</code>. Ao realizar qualquer mutação (início de requisição, carregamento de dados ou erro), o ViewModel executa <code>notifyListeners()</code>, notificando os observadores sem precisar que a View gerencie timers ou callbacks manuais.", body_style))

    code_snippet = """// lib/viewmodels/auth_viewmodel.dart
Future<bool> login(String email, String senha) async {
  _isLoading = true;
  _mensagemErro = null;
  notifyListeners(); // Notifica a View para desenhar o spinner de progresso

  try {
    final usuario = await _bancoService.autenticar(email, senha);
    if (usuario != null) {
      _usuarioAtual = usuario;
      _isLoading = false;
      notifyListeners(); // Notifica com sucesso
      return true;
    }
  } catch (e) {
    _mensagemErro = 'Falha ao autenticar.';
  }
  _isLoading = false;
  notifyListeners(); // Notifica com erro
  return false;
}"""
    story.append(Paragraph(code_snippet.replace('\n', '<br/>').replace(' ', '&nbsp;'), code_block))

    story.append(Paragraph("<b>3.3. Reatividade Cirúrgica com ListenableBuilder</b>", h2_style))
    story.append(Paragraph("As Views e o aplicativo raiz utilizam o widget nativo <code>ListenableBuilder</code>. Dessa forma, somente o botão ou bloco visual afetado pela mutação é reconstruído, preservando o restante da tela sem re-renderizações desnecessárias e sem exigir bibliotecas externas.", body_style))

    # 4. Diagrama
    story.append(Spacer(1, 4))
    story.append(Paragraph("4. Diagrama da Arquitetura MVVM Implementada", h1_style))

    diag_text = """[VIEW (Telas Declarativas)]
    LoginView (/) | CadastroView (/cadastro) | HomeView (/home) | EditorView (/editor)
          | (Aciona login / cadastro)                  | (Aciona CRUD de docs)
          v                                            v
[VIEWMODEL (Regras de Negócio / ChangeNotifier)]
    AuthViewModel                               DocumentosViewModel
          ^ (notifyListeners)                          ^ (notifyListeners)
          | (ListenableBuilder escuta e reconstrói UI) |
          v                                            v
[MODEL / SERVICES (Entidades e Persistência Local)]
    PreferencesService (shared_preferences) | BancoLocalService (CRUD de Usuários e Docs)
    Usuario (Entidade de Dados)             | Documento (Entidade de Dados)"""

    story.append(Paragraph(diag_text.replace('\n', '<br/>').replace(' ', '&nbsp;'), code_block))

    # 5. Entrega
    story.append(Spacer(1, 4))
    story.append(Paragraph("5. Instruções de Entrega e Acesso de Teste", h1_style))
    box_entrega = Table(
        [[Paragraph("<b>Credenciais de Teste Rápido:</b> E-mail: <code>admin@exemplo.com</code> | Senha: <code>123456</code><br/>"
                    "<b>Forma de Entrega no Blackboard:</b> Enviar o link do repositório público no GitHub (ex: <code>https://github.com/SEU-USUARIO/edit-doc-flutter</code>) contendo o código migrado e este documento.", box_style)]],
        colWidths=[520]
    )
    box_entrega.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, -1), colors.HexColor('#f0fdf4')),
        ('BOX', (0, 0), (-1, -1), 1, colors.HexColor('#22c55e')),
        ('TOPPADDING', (0, 0), (-1, -1), 6),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
        ('LEFTPADDING', (0, 0), (-1, -1), 8),
        ('RIGHTPADDING', (0, 0), (-1, -1), 8),
    ]))
    story.append(box_entrega)

    doc.build(story, canvasmaker=NumberedCanvas)
    print(f"PDF gerado com sucesso em: {caminho_saida}")

if __name__ == "__main__":
    caminho = os.path.abspath("RELATORIO_ARQUITETURA.pdf")
    gerar_relatorio_pdf(caminho)
