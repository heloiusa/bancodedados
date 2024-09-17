-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`ferias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ferias` (
  `idferias` INT NOT NULL AUTO_INCREMENT,
  `inicio_ferias` DATE NOT NULL,
  `fim_ferias` DATE NOT NULL,
  PRIMARY KEY (`idferias`),
  UNIQUE INDEX `idferias_UNIQUE` (`idferias` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`gerenciar`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`gerenciar` (
  `id_gerenciar` INT NOT NULL,
  `ponto` DATETIME NOT NULL,
  `saida` DATETIME NOT NULL,
  `departamento_id_departamento` INT NOT NULL,
  `departamento_supervisionar_id_supervisionar` INT NOT NULL,
  PRIMARY KEY (`id_gerenciar`, `departamento_id_departamento`, `departamento_supervisionar_id_supervisionar`),
  UNIQUE INDEX `idgerenciar_UNIQUE` (`id_gerenciar` ASC) VISIBLE,
  INDEX `fk_gerenciar_departamento1_idx` (`departamento_id_departamento` ASC, `departamento_supervisionar_id_supervisionar` ASC) VISIBLE,
  CONSTRAINT `fk_gerenciar_departamento1`
    FOREIGN KEY (`departamento_id_departamento` , `departamento_supervisionar_id_supervisionar`)
    REFERENCES `mydb`.`departamento` (`id_departamento` , `supervisionar_id_supervisionar`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`empregado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`empregado` (
  `id_empregado` INT NOT NULL AUTO_INCREMENT,
  `CPF` VARCHAR(14) NOT NULL,
  `salario` DECIMAL(7,2) NOT NULL,
  `escolaridade` VARCHAR(200) NOT NULL,
  `nome_empregado` VARCHAR(200) NOT NULL,
  `sexo_empregado` CHAR(1) NOT NULL,
  `data_nasc` DATE NOT NULL,
  `ferias_idferias` INT NOT NULL,
  `gerenciar_id_gerenciar` INT NOT NULL,
  PRIMARY KEY (`id_empregado`, `CPF`, `gerenciar_id_gerenciar`),
  UNIQUE INDEX `id_empregado_UNIQUE` (`id_empregado` ASC) VISIBLE,
  UNIQUE INDEX `CPF_UNIQUE` (`CPF` ASC) VISIBLE,
  INDEX `fk_empregado_ferias1_idx` (`ferias_idferias` ASC) VISIBLE,
  INDEX `fk_empregado_gerenciar1_idx` (`gerenciar_id_gerenciar` ASC) VISIBLE,
  CONSTRAINT `fk_empregado_ferias1`
    FOREIGN KEY (`ferias_idferias`)
    REFERENCES `mydb`.`ferias` (`idferias`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_empregado_gerenciar1`
    FOREIGN KEY (`gerenciar_id_gerenciar`)
    REFERENCES `mydb`.`gerenciar` (`id_gerenciar`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`funcao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`funcao` (
  `id_funcao` INT NOT NULL AUTO_INCREMENT,
  `tipo_funcao` VARCHAR(45) NOT NULL,
  `empregado_id_empregado` INT NOT NULL,
  `empregado_CPF` VARCHAR(14) NOT NULL,
  `empregado_gerenciar_id_gerenciar` INT NOT NULL,
  PRIMARY KEY (`id_funcao`),
  UNIQUE INDEX `idfuncao_UNIQUE` (`id_funcao` ASC) VISIBLE,
  INDEX `fk_funcao_empregado1_idx` (`empregado_id_empregado` ASC, `empregado_CPF` ASC, `empregado_gerenciar_id_gerenciar` ASC) VISIBLE,
  CONSTRAINT `fk_funcao_empregado1`
    FOREIGN KEY (`empregado_id_empregado` , `empregado_CPF` , `empregado_gerenciar_id_gerenciar`)
    REFERENCES `mydb`.`empregado` (`id_empregado` , `CPF` , `gerenciar_id_gerenciar`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`projetos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`projetos` (
  `id_projetos` INT NOT NULL AUTO_INCREMENT,
  `nome_projeto` VARCHAR(100) NOT NULL,
  `funcao_id_funcao` INT NOT NULL,
  PRIMARY KEY (`id_projetos`),
  UNIQUE INDEX `idprojetos_UNIQUE` (`id_projetos` ASC) VISIBLE,
  INDEX `fk_projetos_funcao1_idx` (`funcao_id_funcao` ASC) VISIBLE,
  CONSTRAINT `fk_projetos_funcao1`
    FOREIGN KEY (`funcao_id_funcao`)
    REFERENCES `mydb`.`funcao` (`id_funcao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`endereco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`endereco` (
  `id_endereco` INT NOT NULL AUTO_INCREMENT,
  `UF` VARCHAR(2) NOT NULL,
  `CEP` VARCHAR(9) NOT NULL,
  `rua` VARCHAR(180) NOT NULL,
  `bairro` VARCHAR(180) NOT NULL,
  `numero` VARCHAR(45) NOT NULL,
  `complemento` VARCHAR(200) NOT NULL,
  `enderecocol` VARCHAR(45) NOT NULL,
  `projetos_id_projetos` INT NOT NULL,
  `empregado_id_empregado` INT NOT NULL,
  `empregado_CPF` VARCHAR(14) NOT NULL,
  PRIMARY KEY (`id_endereco`),
  UNIQUE INDEX `id_endereco_UNIQUE` (`id_endereco` ASC) VISIBLE,
  INDEX `fk_endereco_projetos1_idx` (`projetos_id_projetos` ASC) VISIBLE,
  INDEX `fk_endereco_empregado1_idx` (`empregado_id_empregado` ASC, `empregado_CPF` ASC) VISIBLE,
  CONSTRAINT `fk_endereco_projetos1`
    FOREIGN KEY (`projetos_id_projetos`)
    REFERENCES `mydb`.`projetos` (`id_projetos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_endereco_empregado1`
    FOREIGN KEY (`empregado_id_empregado` , `empregado_CPF`)
    REFERENCES `mydb`.`empregado` (`id_empregado` , `CPF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`alocacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`alocacao` (
  `id_alocacao` INT NOT NULL AUTO_INCREMENT,
  `horas_trabalhadas` VARCHAR(45) NOT NULL,
  `empregado_id_empregado` INT NOT NULL,
  `empregado_CPF` VARCHAR(14) NOT NULL,
  UNIQUE INDEX `id_alocacao_UNIQUE` (`id_alocacao` ASC) VISIBLE,
  PRIMARY KEY (`id_alocacao`),
  INDEX `fk_alocacao_empregado1_idx` (`empregado_id_empregado` ASC, `empregado_CPF` ASC) VISIBLE,
  CONSTRAINT `fk_alocacao_empregado1`
    FOREIGN KEY (`empregado_id_empregado` , `empregado_CPF`)
    REFERENCES `mydb`.`empregado` (`id_empregado` , `CPF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`supervisionar`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`supervisionar` (
  `id_supervisionar` INT NOT NULL,
  `empregado_id_empregado` INT NOT NULL,
  `empregado_CPF` VARCHAR(14) NOT NULL,
  PRIMARY KEY (`id_supervisionar`, `empregado_id_empregado`, `empregado_CPF`),
  UNIQUE INDEX `id_supervisionar_UNIQUE` (`id_supervisionar` ASC) VISIBLE,
  INDEX `fk_supervisionar_empregado1_idx` (`empregado_id_empregado` ASC, `empregado_CPF` ASC) VISIBLE,
  CONSTRAINT `fk_supervisionar_empregado1`
    FOREIGN KEY (`empregado_id_empregado` , `empregado_CPF`)
    REFERENCES `mydb`.`empregado` (`id_empregado` , `CPF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`departamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`departamento` (
  `id_departamento` INT NOT NULL AUTO_INCREMENT,
  `nome_departmento` VARCHAR(100) NOT NULL,
  `endereco_id_endereco` INT NOT NULL,
  `alocacao_id_alocacao` INT NOT NULL,
  `supervisionar_id_supervisionar` INT NOT NULL,
  PRIMARY KEY (`id_departamento`, `supervisionar_id_supervisionar`),
  UNIQUE INDEX `iddepartamento_UNIQUE` (`id_departamento` ASC) VISIBLE,
  INDEX `fk_departamento_endereco1_idx` (`endereco_id_endereco` ASC) VISIBLE,
  INDEX `fk_departamento_alocacao1_idx` (`alocacao_id_alocacao` ASC) VISIBLE,
  INDEX `fk_departamento_supervisionar1_idx` (`supervisionar_id_supervisionar` ASC) VISIBLE,
  CONSTRAINT `fk_departamento_endereco1`
    FOREIGN KEY (`endereco_id_endereco`)
    REFERENCES `mydb`.`endereco` (`id_endereco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_departamento_alocacao1`
    FOREIGN KEY (`alocacao_id_alocacao`)
    REFERENCES `mydb`.`alocacao` (`id_alocacao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_departamento_supervisionar1`
    FOREIGN KEY (`supervisionar_id_supervisionar`)
    REFERENCES `mydb`.`supervisionar` (`id_supervisionar`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`dependente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`dependente` (
  `id_dependente` INT NOT NULL AUTO_INCREMENT,
  `nome_dependente` VARCHAR(200) NOT NULL,
  `sexo_dependente` CHAR(1) NOT NULL,
  `data_nasc` DATE NOT NULL,
  `empregado_id_empregado` INT NOT NULL,
  `empregado_CPF` VARCHAR(14) NOT NULL,
  PRIMARY KEY (`id_dependente`),
  UNIQUE INDEX `id_dependente_UNIQUE` (`id_dependente` ASC) VISIBLE,
  INDEX `fk_dependente_empregado_idx` (`empregado_id_empregado` ASC, `empregado_CPF` ASC) VISIBLE,
  CONSTRAINT `fk_dependente_empregado`
    FOREIGN KEY (`empregado_id_empregado` , `empregado_CPF`)
    REFERENCES `mydb`.`empregado` (`id_empregado` , `CPF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`cargo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`cargo` (
  `id_cargo` INT NOT NULL,
  `tipo_cargo` VARCHAR(180) NOT NULL,
  `empregado_id_empregado` INT NOT NULL,
  `empregado_CPF` VARCHAR(14) NOT NULL,
  `departamento_id_departamento` INT NOT NULL,
  `departamento_supervisionar_id_supervisionar` INT NOT NULL,
  PRIMARY KEY (`id_cargo`, `empregado_id_empregado`, `empregado_CPF`, `departamento_id_departamento`, `departamento_supervisionar_id_supervisionar`),
  UNIQUE INDEX `idcargo_UNIQUE` (`id_cargo` ASC) VISIBLE,
  INDEX `fk_cargo_empregado1_idx` (`empregado_id_empregado` ASC, `empregado_CPF` ASC) VISIBLE,
  INDEX `fk_cargo_departamento1_idx` (`departamento_id_departamento` ASC, `departamento_supervisionar_id_supervisionar` ASC) VISIBLE,
  CONSTRAINT `fk_cargo_empregado1`
    FOREIGN KEY (`empregado_id_empregado` , `empregado_CPF`)
    REFERENCES `mydb`.`empregado` (`id_empregado` , `CPF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cargo_departamento1`
    FOREIGN KEY (`departamento_id_departamento` , `departamento_supervisionar_id_supervisionar`)
    REFERENCES `mydb`.`departamento` (`id_departamento` , `supervisionar_id_supervisionar`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
