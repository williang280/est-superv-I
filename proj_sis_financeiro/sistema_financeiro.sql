CREATE DATABASE db_financas;
USE db_financas;
CREATE TABLE Usuarios (
    usuario_id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_nome VARCHAR(100) NOT NULL,
    usuario_email VARCHAR(100) NOT NULL UNIQUE,
    usuario_senha VARCHAR(255) NOT NULL,
    usuario_telefone VARCHAR(15) NOT NULL UNIQUE,
    usuario_data_nascimento DATE NOT NULL,
    usuario_endereco VARCHAR(150) NOT NULL,
    usuario_cidade VARCHAR(50) NOT NULL,
    usuario_estado CHAR(2) NOT NULL,
    usuario_status ENUM('ativo', 'inativo') NOT NULL
);

CREATE TABLE Clientes (
    cliente_id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    cliente_nome VARCHAR(100) NOT NULL,
    cliente_sobrenome VARCHAR(100) NOT NULL,
    cliente_email VARCHAR(100) NOT NULL UNIQUE,
    cliente_telefone VARCHAR(15) NOT NULL UNIQUE,
    cliente_cpf VARCHAR(14) NOT NULL UNIQUE,
    cliente_rg VARCHAR(20) NOT NULL UNIQUE,
    cliente_data_nascimento DATE NOT NULL,
    cliente_endereco VARCHAR(150) NOT NULL,
    cliente_numero VARCHAR(10) NOT NULL,
    cliente_complemento VARCHAR(50),
    cliente_bairro VARCHAR(50) NOT NULL,
    cliente_cidade VARCHAR(50) NOT NULL,
    cliente_estado CHAR(2) NOT NULL,
    cliente_cep VARCHAR(10) NOT NULL,
    cliente_pais VARCHAR(50) NOT NULL,
    cliente_data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cliente_status ENUM('ativo', 'inativo') NOT NULL,
    cliente_limite_credito DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    cliente_observacoes TEXT,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(usuario_id)
);

CREATE TABLE Controle_Contatos_Cliente (
    contato_id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    contato_nome VARCHAR(100) NOT NULL,
    contato_email VARCHAR(100),
    contato_telefone VARCHAR(15),
    contato_data DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    contato_motivo VARCHAR(255) NOT NULL,
    contato_meio ENUM('telefone', 'email', 'presencial') NOT NULL,
    contato_observacao TEXT,
    contato_status ENUM('pendente', 'resolvido') NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id)
);

CREATE TABLE Fornecedores (
    fornecedor_id INT PRIMARY KEY AUTO_INCREMENT,
    fornecedor_nome VARCHAR(100) NOT NULL,
    fornecedor_cnpj VARCHAR(18) NOT NULL UNIQUE,
    fornecedor_email VARCHAR(100),
    fornecedor_telefone VARCHAR(15),
    fornecedor_endereco VARCHAR(150),
    fornecedor_cidade VARCHAR(50),
    fornecedor_estado CHAR(2),
    fornecedor_cep VARCHAR(10),
    fornecedor_status ENUM('ativo', 'inativo') NOT NULL
);

CREATE TABLE Controle_Banco (
    banco_id INT PRIMARY KEY AUTO_INCREMENT,
    banco_nome VARCHAR(100) NOT NULL,
    banco_agencia VARCHAR(10) NOT NULL,
    banco_conta VARCHAR(20) NOT NULL UNIQUE,
    banco_tipo ENUM('corrente', 'poupança') NOT NULL,
    banco_saldo DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    banco_limite DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    banco_ultima_movimentacao DATETIME,
    banco_status ENUM('ativo', 'inativo') NOT NULL,
    banco_observacao TEXT
);

CREATE TABLE Controle_Cartoes (
    cartao_id INT PRIMARY KEY AUTO_INCREMENT,
    banco_id INT NOT NULL,
    cartao_numero VARCHAR(20) NOT NULL UNIQUE,
    cartao_bandeira VARCHAR(50) NOT NULL,
    cartao_limite DECIMAL(10,2) NOT NULL CHECK (cartao_limite >= 0),
    cartao_status ENUM('ativo', 'bloqueado') NOT NULL,
    FOREIGN KEY (banco_id) REFERENCES Controle_Banco(banco_id)
);

CREATE TABLE Controle_Contas (
    conta_id INT PRIMARY KEY AUTO_INCREMENT,
    banco_id INT NOT NULL,
    conta_descricao VARCHAR(255) NOT NULL,
    conta_tipo ENUM('corrente', 'poupança', 'investimento') NOT NULL,
    conta_saldo DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    conta_status ENUM('ativa', 'inativa') NOT NULL,
    FOREIGN KEY (banco_id) REFERENCES Controle_Banco(banco_id)
);

CREATE TABLE Receitas (
    receita_id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    banco_id INT NOT NULL,
    receita_descricao VARCHAR(255) NOT NULL,
    receita_valor DECIMAL(10,2) NOT NULL CHECK (receita_valor > 0),
    receita_data DATE NOT NULL,
    receita_categoria VARCHAR(50) NOT NULL,
    receita_origem VARCHAR(100) NOT NULL,
    receita_status ENUM('pendente', 'recebido') NOT NULL,
    receita_observacao TEXT,
    FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id),
    FOREIGN KEY (banco_id) REFERENCES Controle_Banco(banco_id)
);

CREATE TABLE Despesas (
    despesa_id INT PRIMARY KEY AUTO_INCREMENT,
    fornecedor_id INT NOT NULL,
    banco_id INT NOT NULL,
    despesa_descricao VARCHAR(255) NOT NULL,
    despesa_valor DECIMAL(10,2) NOT NULL CHECK (despesa_valor > 0),
    despesa_data DATE NOT NULL,
    despesa_categoria VARCHAR(50) NOT NULL,
    despesa_destino VARCHAR(100) NOT NULL,
    despesa_status ENUM('pendente', 'pago') NOT NULL,
    despesa_observacao TEXT,
    FOREIGN KEY (fornecedor_id) REFERENCES Fornecedores(fornecedor_id),
    FOREIGN KEY (banco_id) REFERENCES Controle_Banco(banco_id)
);

CREATE TABLE Controle_Pagamentos (
    pagamento_id INT PRIMARY KEY AUTO_INCREMENT,
    fornecedor_id INT,
    banco_id INT NOT NULL,
    cartao_id INT,
    pagamento_descricao VARCHAR(255) NOT NULL,
    pagamento_valor DECIMAL(10,2) NOT NULL CHECK (pagamento_valor > 0),
    pagamento_data DATE NOT NULL,
    pagamento_vencimento DATE NOT NULL,
    pagamento_status ENUM('pendente', 'pago') NOT NULL,
    pagamento_metodo ENUM('dinheiro', 'cartão', 'boleto', 'transferência') NOT NULL,
    pagamento_parcelas INT NOT NULL DEFAULT 1 CHECK (pagamento_parcelas > 0),
    pagamento_observacao TEXT,
    FOREIGN KEY (fornecedor_id) REFERENCES Fornecedores(fornecedor_id),
    FOREIGN KEY (banco_id) REFERENCES Controle_Banco(banco_id),
    FOREIGN KEY (cartao_id) REFERENCES Controle_Cartoes(cartao_id)
);