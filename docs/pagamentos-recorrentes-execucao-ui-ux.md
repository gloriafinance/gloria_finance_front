# Execução mensal de pagamentos recorrentes — UI/UX

Esta entrega reorganiza o `RecurringPaymentExecutionSheet` para que a primeira decisão seja a conta de origem. A capacidade fica no modelo de apresentação local `RecurringPaymentSourceUiModel`; não há provider inferido a partir de nome, tag, banco ou identificador.

## Decisão e state machine

`session.asaasConnect` é usada apenas para oferecer a opção de apresentação “Conta Asaas”. Cada `AvailabilityAccount` ativa aparece como fonte manual. A fonte selecionada é guardada em `RecurringPaymentExecutionState.selectedPaymentSource`, e `capability` determina a jornada:

```text
paymentSource
├── manual → manualRegistration → result
└── asaas → asaasMethod
             ├── boletoEntry → boletoCamera | boletoLine
             │                 → boletoValidating → boletoConfirmation → result
             ├── pixQrEntry → pixQrCamera | pixQrPaste
             │               → pixQrAmount (QR sem valor + VARIABLE)
             │               → pixQrPreview → result
             └── existingPixKeyFlow (atalho da chave já configurada)
```

Os widgets dos passos ficam separados em `pages/execution/widgets/`. O botão de voltar retorna à seleção de conta ou à etapa anterior do instrumento. No desktop a fonte é apresentada em até duas colunas; no mobile, em uma coluna.

## Matriz conta × fluxo

| Fonte selecionada | Fluxos disponíveis |
| --- | --- |
| Itaú, Caixa, dinheiro ou outra `AvailabilityAccount` ativa | Registro manual com data, conta selecionada somente leitura, valor fixo somente leitura ou valor variável editável e comprovante obrigatório. Não exibe boleto nem QR. |
| Conta Asaas (opção local exibida quando `session.asaasConnect == true`) | Seleção entre Boleto e PIX QR. Boleto aceita câmera ou linha digitável de 44/47/48 dígitos. PIX QR aceita câmera ou copia e cola. A chave PIX já configurada permanece como atalho secundário. |
| Igreja sem Asaas | Fontes manuais existentes; não oferece instrumento bancário. |

## Jornadas

1. **Conta não integrada → comprovante**: escolher uma conta normal abre o registro manual sem perguntar a conta novamente. O valor é herdado quando FIXED e editável quando VARIABLE. O comprovante é obrigatório. O submit continua usando a integração manual já existente.
2. **Conta Asaas → boleto**: escolher Boleto abre câmera ou linha digitável. O valor nunca é digitado. A etapa de validação usa estado local e mostra beneficiário, vencimento, valor, conta e linha mascarada. Em FIXED, valores divergentes desabilitam confirmar.
3. **Conta Asaas → PIX QR**: escolher PIX QR abre scanner QR separado ou copia e cola. A leitura usa fixture local. QR com valor adota o valor lido. QR sem valor pede quantia apenas para VARIABLE; FIXED usa a configuração. Divergência FIXED desabilita confirmar.

O fluxo PIX por chave existente permanece disponível como atalho secundário quando há destino cadastrado.

## Limites desta entrega

- O modelo de fonte é de apresentação e existe apenas dentro do feature. As contas normais são apresentadas como manuais; a API ainda não identifica qual `AvailabilityAccount` corresponde ao Asaas.
- Os dados do preview de boleto e PIX QR (beneficiário/recebedor, documento, vencimento, identificador e quantia) são fixtures locais.
- “Validando boleto”, leitura do QR, validação e confirmação são estados locais. Os novos fluxos não chamam `simulate`, `decode`, `pay`, church-banking nem Asaas.
- `mobile_scanner` é usado para leitura da câmera; permissões e erros são tratados na UI, com alternativa de entrada manual sempre visível.
- O callback `onManualRegister` permite completar cenários de demonstração/teste sem request. Sem callback, permanece a integração manual existente.
- O caminho PIX por chave e sua integração preexistente foram preservados.

## Capturas visuais

O teste `test/features/erp/recurring_payments/recurring_payments_execution_visual_test.dart` gera as capturas em `docs/pagamentos-recorrentes-execucao/` com `--dart-define=GENERATE_SCREENSHOTS=true`:

### Mobile 390×844

- `mobile-01-selecao-conta.png`
- `mobile-02-registro-manual.png`
- `mobile-03-asaas-instrumento.png`
- `mobile-04-boleto-linha.png`
- `mobile-05-boleto-preview.png`
- `mobile-06-qr-scanner.png`
- `mobile-07-qr-preview.png`

### Desktop 1440×900

- `desktop-01-selecao-conta.png`
- `desktop-02-asaas-instrumento.png`
- `desktop-03-boleto-preview.png`
- `desktop-04-qr-preview.png`

## Integração futura necessária

O backend deve informar a relação confiável entre conta e provider antes de identificar contas Asaas reais. Também serão necessários contratos para simular boleto, decodificar QR Pix e confirmar o pagamento dos novos instrumentos. As fixtures da demonstração precisam ser substituídas por respostas reais quando esses contratos existirem. Esta entrega não implementa essas integrações.
