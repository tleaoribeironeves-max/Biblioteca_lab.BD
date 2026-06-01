USE BIBLIOTECA;

CREATE TABLE AUTOR (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45) NOT NULL
);

CREATE TABLE livro (
    id_livro INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(45) NOT NULL,
    ano_publicacao INT,
    qtd_disponivel INT NOT NULL DEFAULT 1,
	CONSTRAINT chk_qtd CHECK (qtd_disponivel >= 0)
);

CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45) NOT NULL,
    cpf VARCHAR(45) UNIQUE NOT NULL,
    email VARCHAR(45) UNIQUE NOT NULL,
    telefone VARCHAR(11)
);

CREATE TABLE emprestimo (
    id_emprestimo INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    data_emprestimo DATE NOT NULL,
    data_devolucao DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'ATIVO',
    CONSTRAINT fk_emp_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    CONSTRAINT chk_status CHECK (status IN ('ATIVO', 'DEVOLVIDO', 'ATRASADO'))
);

CREATE TABLE autor_livro (
    autor_id_autor INT NOT NULL,
    livro_id_livro INT NOT NULL,
    PRIMARY KEY (autor_id_autor, livro_id_livro),
    CONSTRAINT fk_autor_livro_autor FOREIGN KEY (autor_id_autor) REFERENCES autor(id_autor) ON DELETE CASCADE,
	CONSTRAINT fk_autor_livro_livro FOREIGN KEY (livro_id_livro) REFERENCES livro(id_livro) ON DELETE CASCADE
);

CREATE TABLE livro_emprestimo (
    livro_id_livro INT NOT NULL,
    emprestimo_id_emprestimo INT NOT NULL,
	PRIMARY KEY (livro_id_livro, emprestimo_id_emprestimo),
	FOREIGN KEY (livro_id_livro) REFERENCES livro(id_livro),
	FOREIGN KEY (emprestimo_id_emprestimo) REFERENCES emprestimo(id_emprestimo)
);


CREATE VIEW v_emprestimos_ativos AS
SELECT e.id_emprestimo, u.nome AS usuario, l.titulo AS livro, e.data_emprestimo
FROM emprestimo e
JOIN usuario u ON e.id_usuario = u.id_usuario
JOIN livro l ON e.id_livro = l.id_livro
WHERE e.status = 'ATIVO';