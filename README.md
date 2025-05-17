# EEL480-Sistemas-Digitais

Repositório criado para compartilhar os trabalhos realizados na materia de Sistemas-Digitais/UFRJ

O módulo criado para ALU realiza operações com dois operandos de 4 bits (num_1 e num_2), controladas por um código de operação de 3 bits (op). A saída da ALU é um vetor de 8 bits (result), composto por 4 flags e o resultado de 4 bits da operação.
A ALU opera de acordo com o valor da entrada op, com as seguintes funções:

"000" →  Soma: Soma os operandos como números com sinal. Calcula as flags carry_out, zero, negative e overflow.

"001" →  Subtração: Subtrai num_2 de num_1, com o mesmo tratamento de flags da soma.

"010" →  AND: Operação lógica bit a bit.

"011" →  OR: Operação lógica bit a bit.

"100" →  XOR: Operação lógica exclusiva.

"101" →  Comparação: Retorna 1 se iguais, 2 se num_1 < num_2,  se num_1 > num_2.

"110" →  Shift lógico à esquerda: Realiza deslocamento de num_1 para a esquerda, com a quantidade indicada por num_2.

"111" →  Shift lógico à direita: Realiza deslocamento de num_1 para a direita, com a quantidade indicada por num_2.

A saída result é formada pela concatenação dos sinais: [overflow], [zero], [negative], [carry_out] e [resultado de 4 bits]. Cabe destacar que todos os sinais são atualizados a cada borda de subida do clock, garantindo sincronia com o sistema.
