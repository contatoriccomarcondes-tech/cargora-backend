-- ==============================
-- CARGORA DATABASE STRUCTURE
-- ==============================


-- ==============================
-- TABELA DE CIDADES (IBGE)
-- ==============================

CREATE TABLE cidades (
    id SERIAL PRIMARY KEY,
    codigo_ibge INTEGER UNIQUE,
    nome VARCHAR(100) NOT NULL,
    estado VARCHAR(2) NOT NULL
);


-- ==============================
-- TABELA TRANSPORTADORAS
-- ==============================

CREATE TABLE transportadoras (
    id SERIAL PRIMARY KEY,

    razao_social VARCHAR(200),
    nome_fantasia VARCHAR(200),

    cnpj VARCHAR(20) UNIQUE NOT NULL,
    antt VARCHAR(20),

    telefone VARCHAR(20),
    email VARCHAR(200) UNIQUE NOT NULL,

    senha_hash TEXT NOT NULL,

    cidade_base_id INTEGER REFERENCES cidades(id),

    status_verificacao VARCHAR(20) DEFAULT 'pendente',

    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ==============================
-- TABELA MOTORISTAS
-- ==============================

CREATE TABLE motoristas (
    id SERIAL PRIMARY KEY,

    nome VARCHAR(200) NOT NULL,

    cpf VARCHAR(20) UNIQUE NOT NULL,

    telefone VARCHAR(20),

    email VARCHAR(200) UNIQUE NOT NULL,

    senha_hash TEXT NOT NULL,

    cidade_base_id INTEGER REFERENCES cidades(id),

    veiculo_tipo VARCHAR(50),

    capacidade_toneladas NUMERIC,

    tipo_carroceria VARCHAR(50),

    status_verificacao VARCHAR(20) DEFAULT 'pendente',

    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ==============================
-- TABELA CARGAS
-- ==============================

CREATE TABLE cargas (
    id SERIAL PRIMARY KEY,

    transportadora_id INTEGER REFERENCES transportadoras(id),

    origem_cidade_id INTEGER REFERENCES cidades(id),

    destino_cidade_id INTEGER REFERENCES cidades(id),

    tipo_carga VARCHAR(100),

    peso_total NUMERIC,

    peso_disponivel NUMERIC,

    veiculo_recomendado VARCHAR(50),

    tipo_frete VARCHAR(20),

    valor_por_ton NUMERIC,

    valor_fechado NUMERIC,

    whatsapp_contato VARCHAR(20),

    status VARCHAR(20) DEFAULT 'ativa',

    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ==============================
-- TABELA DOCUMENTOS
-- ==============================

CREATE TABLE documentos (
    id SERIAL PRIMARY KEY,

    usuario_tipo VARCHAR(20), -- motorista ou transportadora

    usuario_id INTEGER,

    tipo_documento VARCHAR(50),

    arquivo_url TEXT,

    enviado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ==============================
-- EVENTOS DA CARGA
-- ==============================

CREATE TABLE eventos_carga (
    id SERIAL PRIMARY KEY,

    carga_id INTEGER REFERENCES cargas(id),

    evento VARCHAR(50),

    descricao TEXT,

    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ==============================
-- AVALIAÇÕES FUTURAS
-- ==============================

CREATE TABLE avaliacoes (
    id SERIAL PRIMARY KEY,

    carga_id INTEGER REFERENCES cargas(id),

    motorista_id INTEGER REFERENCES motoristas(id),

    transportadora_id INTEGER REFERENCES transportadoras(id),

    nota INTEGER,

    comentario TEXT,

    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ==============================
-- ÍNDICES PARA PERFORMANCE
-- ==============================

CREATE INDEX idx_cargas_origem
ON cargas(origem_cidade_id);

CREATE INDEX idx_cargas_destino
ON cargas(destino_cidade_id);

CREATE INDEX idx_cargas_status
ON cargas(status);

CREATE INDEX idx_motoristas_cidade
ON motoristas(cidade_base_id);

CREATE INDEX idx_transportadoras_cidade
ON transportadoras(cidade_base_id);
