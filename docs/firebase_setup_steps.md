# Firebase setup final (storage + catalogo)

## 1) Ativar Firebase Storage
1. Acesse o console: https://console.firebase.google.com/project/aminhabiblia-558d1/storage
2. Clique em **Get Started**.
3. Escolha qualquer regiao padrao.

## 2) Publicar regras
No diretorio raiz do projeto:

```powershell
firebase deploy --only firestore:rules,storage
```

## 3) Fazer upload das 7 versoes para o bucket
Pre-requisito: `gcloud` instalado e autenticado (`gcloud auth login`).

```powershell
./scripts/upload_bibles_to_storage.ps1
```

Os ficheiros serao enviados para:
- bibles/ACF.json
- bibles/ARA.json
- bibles/ARC.json
- bibles/KJF.json
- bibles/NVI.json
- bibles/NVT.json
- bibles/NTLH.json

## 4) Seed da colecao bible_versions (opcao B)
### Opcao A (recomendada): script com credencial de service account
1. Crie uma service account no GCP/Firebase com permissao Firestore Admin.
2. Baixe o JSON da chave.
3. Defina variavel no Windows:

```powershell
setx GOOGLE_APPLICATION_CREDENTIALS "C:\caminho\service-account.json"
```

4. Abra novo terminal e rode:

```powershell
cd functions
npm run seed:bible-versions
```

### Opcao B: inserir manualmente
Use os dados de:
- functions/seed/bible_versions.json

Colecao alvo:
- bible_versions

## Observacao
Mesmo sem seed remoto, a app possui fallback local para nome/tamanho/caminho das 7 versoes.
