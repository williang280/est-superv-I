from django.db import models

class Usuario(models.Model):
    STATUS_CHOICES = [
        ('ativo', 'Ativo'),
        ('inativo', 'Inativo'),
    ]

    usuario_nome = models.CharField(max_length=100)
    usuario_email = models.EmailField(unique=True)
    usuario_senha = models.CharField(max_length=255)
    usuario_telefone = models.CharField(max_length=15, unique=True)
    usuario_data_nascimento = models.DateField()
    usuario_endereco = models.CharField(max_length=150)
    usuario_cidade = models.CharField(max_length=50)
    usuario_estado = models.CharField(max_length=2)
    usuario_status = models.CharField(max_length=7, choices=STATUS_CHOICES)

    def __str__(self):
        return self.usuario_nome

class Cliente(models.Model):
    STATUS_CHOICES = [
        ('ativo', 'Ativo'),
        ('inativo', 'Inativo'),
    ]

    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    cliente_nome = models.CharField(max_length=100)
    cliente_sobrenome = models.CharField(max_length=100)
    cliente_email = models.EmailField(unique=True)
    cliente_telefone = models.CharField(max_length=15, unique=True)
    cliente_cpf = models.CharField(max_length=14, unique=True)
    cliente_rg = models.CharField(max_length=20, unique=True)
    cliente_data_nascimento = models.DateField()
    cliente_endereco = models.CharField(max_length=150)
    cliente_numero = models.CharField(max_length=10)
    cliente_complemento = models.CharField(max_length=50, blank=True, null=True)
    cliente_bairro = models.CharField(max_length=50)
    cliente_cidade = models.CharField(max_length=50)
    cliente_estado = models.CharField(max_length=2)
    cliente_cep = models.CharField(max_length=10)
    cliente_pais = models.CharField(max_length=50)
    cliente_data_cadastro = models.DateTimeField(auto_now_add=True)
    cliente_status = models.CharField(max_length=7, choices=STATUS_CHOICES)
    cliente_limite_credito = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    cliente_observacoes = models.TextField(blank=True, null=True)

    def __str__(self):
        return f'{self.cliente_nome} {self.cliente_sobrenome}'

class ControleContatoCliente(models.Model):
    STATUS_CHOICES = [
        ('pendente', 'Pendente'),
        ('resolvido', 'Resolvido'),
    ]
    MEIO_CHOICES = [
        ('telefone', 'Telefone'),
        ('email', 'Email'),
        ('presencial', 'Presencial'),
    ]

    cliente = models.ForeignKey(Cliente, on_delete=models.CASCADE)
    contato_nome = models.CharField(max_length=100)
    contato_email = models.EmailField(blank=True, null=True)
    contato_telefone = models.CharField(max_length=15, blank=True, null=True)
    contato_data = models.DateTimeField(auto_now_add=True)
    contato_motivo = models.CharField(max_length=255)
    contato_meio = models.CharField(max_length=10, choices=MEIO_CHOICES)
    contato_observacao = models.TextField(blank=True, null=True)
    contato_status = models.CharField(max_length=9, choices=STATUS_CHOICES)

    def __str__(self):
        return f'Contato de {self.contato_nome}'

class Fornecedor(models.Model):
    STATUS_CHOICES = [
        ('ativo', 'Ativo'),
        ('inativo', 'Inativo'),
    ]

    fornecedor_nome = models.CharField(max_length=100)
    fornecedor_cnpj = models.CharField(max_length=18, unique=True)
    fornecedor_email = models.EmailField(blank=True, null=True)
    fornecedor_telefone = models.CharField(max_length=15, blank=True, null=True)
    fornecedor_endereco = models.CharField(max_length=150, blank=True, null=True)
    fornecedor_cidade = models.CharField(max_length=50, blank=True, null=True)
    fornecedor_estado = models.CharField(max_length=2, blank=True, null=True)
    fornecedor_cep = models.CharField(max_length=10, blank=True, null=True)
    fornecedor_status = models.CharField(max_length=7, choices=STATUS_CHOICES)

    def __str__(self):
        return self.fornecedor_nome

class ControleBanco(models.Model):
    STATUS_CHOICES = [
        ('ativo', 'Ativo'),
        ('inativo', 'Inativo'),
    ]
    
    TIPO_CHOICES = [
        ('corrente', 'Corrente'),
        ('poupança', 'Poupança'),
    ]
    
    banco_nome = models.CharField(max_length=100)
    banco_agencia = models.CharField(max_length=10)
    banco_conta = models.CharField(max_length=20, unique=True)
    banco_tipo = models.CharField(max_length=10, choices=TIPO_CHOICES)
    banco_saldo = models.DecimalField(max_digits=15, decimal_places=2, default=0.00)
    banco_limite = models.DecimalField(max_digits=15, decimal_places=2, default=0.00)
    banco_ultima_movimentacao = models.DateTimeField(blank=True, null=True)
    banco_status = models.CharField(max_length=7, choices=STATUS_CHOICES)
    banco_observacao = models.TextField(blank=True, null=True)

    def __str__(self):
        return self.banco_nome

class Receita(models.Model):
    STATUS_CHOICES = [
        ('pendente', 'Pendente'),
        ('recebido', 'Recebido'),
    ]

    cliente = models.ForeignKey(Cliente, on_delete=models.CASCADE)
    banco = models.ForeignKey(ControleBanco, on_delete=models.CASCADE)
    receita_descricao = models.CharField(max_length=255)
    receita_valor = models.DecimalField(max_digits=10, decimal_places=2)
    receita_data = models.DateField()
    receita_categoria = models.CharField(max_length=50)
    receita_origem = models.CharField(max_length=100)
    receita_status = models.CharField(max_length=9, choices=STATUS_CHOICES)
    receita_observacao = models.TextField(blank=True, null=True)

    def __str__(self):
        return self.receita_descricao

class Despesa(models.Model):
    STATUS_CHOICES = [
        ('pendente', 'Pendente'),
        ('pago', 'Pago'),
    ]

    fornecedor = models.ForeignKey(Fornecedor, on_delete=models.CASCADE)
    banco = models.ForeignKey(ControleBanco, on_delete=models.CASCADE)
    despesa_descricao = models.CharField(max_length=255)
    despesa_valor = models.DecimalField(max_digits=10, decimal_places=2)
    despesa_data = models.DateField()
    despesa_categoria = models.CharField(max_length=50)
    despesa_destino = models.CharField(max_length=100)
    despesa_status = models.CharField(max_length=4, choices=STATUS_CHOICES)
    despesa_observacao = models.TextField(blank=True, null=True)

    def __str__(self):
        return self.despesa_descricao