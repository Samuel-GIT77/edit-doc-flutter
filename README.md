<<<<<<< HEAD
# 📝 Editor de Documentos Flutter (`edit-doc-flutter`)

Projeto de aplicação multiplataforma desenvolvido em **Flutter** estruturado rigorosamente sob o padrão de arquitetura **MVVM (Model-View-ViewModel)** com persistência local (`shared_preferences`) e container Linux configurado para execução via **GitHub Codespaces**.

---

## 🚀 Visão Geral da Arquitetura MVVM

A aplicação segue a separação estrita de responsabilidades:
* **Model (`lib/models/`):** Entidades de domínio (`Usuario`, `Documento`) e serviços de persistência e acesso a dados (`PreferencesService`, `BancoLocalService`).
* **ViewModel (`lib/viewmodels/`):** Gerenciadores de estado e regras de negócio herdando de `ChangeNotifier` (`AuthViewModel`, `DocumentosViewModel`).
* **View (`lib/views/`):** Telas declarativas e reativas via `ListenableBuilder` (`LoginView`, `CadastroView`, `HomeView`, `EditorView`).
* **Utils (`lib/utils/`):** Funções utilitárias de validação (`Validadores`).

> 📄 **Relatório Técnico Completo da Migração:** Consulte o arquivo [ARQUITETURA.md](ARQUITETURA.md) para a análise detalhada do mapeamento de classes, alterações de estrutura/imports e gerenciamento de estado sem `setState()`.

---

## 📂 Estrutura de Pastas do Projeto

```
edit-doc-flutter/
├── .devcontainer/
│   └── devcontainer.json         # Configuração do ambiente Linux com Flutter SDK (porta 8080)
├── .vscode/
│   └── launch.json               # Configuração F5 para servidor Web Preview
├── lib/
│   ├── main.dart                 # Ponto de entrada, ThemeData reativo e Rotas Nomeadas
│   ├── models/                   # MODEL: Entidades e serviços
│   │   ├── usuario.dart          # Modelo de dados do Usuário
│   │   ├── documento.dart        # Modelo de dados do Documento
│   │   └── services/
│   │       ├── preferences_service.dart # Persistência com shared_preferences (Tema e preferências)
│   │       └── banco_local_service.dart # Persistência e CRUD de Usuários e Documentos
│   ├── viewmodels/               # VIEWMODEL: Estado e regras de negócio (ChangeNotifier)
│   │   ├── auth_viewmodel.dart   # Autenticação, cadastro e tema
│   │   └── documentos_viewmodel.dart # Listagem e operações CRUD de documentos
│   ├── views/                    # VIEW: Telas da aplicação (apenas interface gráfica)
│   │   ├── login_view.dart       # Rota: /
│   │   ├── cadastro_view.dart   # Rota: /cadastro
│   │   ├── home_view.dart        # Rota: /home
│   │   └── editor_view.dart      # Rota: /editor
│   └── utils/                    # Funções utilitárias
│       └── validadores.dart      # Validações de Nome, E-mail, Senha e Título
├── web/
│   └── index.html                # Ponto de entrada web para visualização
├── ARQUITETURA.md                # Relatório Técnico de Migração Arquitetural
├── pubspec.yaml                  # Dependências do Flutter e shared_preferences
└── README.md
```

---

## 🛠️ Como Executar o Projeto

### Opção 1: No GitHub Codespaces (Recomendado pela Atividade)

1. No repositório no GitHub, clique no botão **Code** > aba **Codespaces** > **Create codespace on main**.
2. Quando o ambiente carregar no navegador, clique em **Trust Folder & Continue**.
3. Pressione a tecla **F5** (ou acesse a aba **Run & Debug** na barra lateral e clique na seta verde **"Rodar App Flutter (Web Preview)"**).
4. O preview web do aplicativo abrirá automaticamente na porta `8080`.

### Opção 2: Via Terminal no Codespaces ou Localmente

Se preferir executar comandos pelo terminal integrado (`Ctrl + '`):

```bash
# Obter as dependências
flutter pub get

# Rodar o servidor web na porta 8080
flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0
```

---

## 🔑 Credenciais Padrão para Testes Rápidos

O serviço local já vem pré-configurado com uma conta e documentos de exemplo:

* **E-mail:** `admin@exemplo.com`
* **Senha:** `123456`

*(Você também pode utilizar a tela de cadastro `/cadastro` para criar uma nova conta a qualquer momento).*

---

## 📋 Funcionalidades Implementadas

* [x] **Autenticação:** Login e Cadastro com validação rigorosa de campos.
* [x] **Preferências de Tema:** Alternância em tempo real entre Modo Claro e Modo Escuro, persistido no navegador/dispositivo.
* [x] **CRUD de Documentos:**
  * Listagem reativa de documentos vinculados ao usuário ativo.
  * Criação de novos documentos com título e corpo.
  * Edição de documentos existentes com atualização de data de modificação.
  * Exclusão com diálogo de confirmação.
* [x] **Arquitetura Reativa MVVM:** Uso de `ChangeNotifier` e `ListenableBuilder` nativos, sem necessidade de pacotes externos para gerenciamento de estado.
* [x] **Rotas Nomeadas:** Navegação desacoplada através de rotas `/`, `/cadastro`, `/home` e `/editor`.

---

## 🛑 Encerramento da Sessão no GitHub Codespaces

Para economizar a cota gratuita mensal de 60 horas do GitHub Codespaces:
1. Faça commit e push das suas alterações:
   ```bash
   git add .
   git commit -m "feat: migracao completa para arquitetura MVVM"
   git push
   ```
2. Acesse [github.com/codespaces](https://github.com/codespaces) e clique em **...** > **Stop Codespace**.
=======
# edit-doc-flutter
>>>>>>> a8a8917b6114e81fd62cef6643d878127091d5ed
