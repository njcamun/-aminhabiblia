const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

function resolveProjectId() {
  if (process.env.GCLOUD_PROJECT) return process.env.GCLOUD_PROJECT;
  if (process.env.GOOGLE_CLOUD_PROJECT) return process.env.GOOGLE_CLOUD_PROJECT;
  if (process.env.FIREBASE_PROJECT_ID) return process.env.FIREBASE_PROJECT_ID;

  const firebaseJsonPath = path.join(__dirname, '..', 'firebase.json');
  if (fs.existsSync(firebaseJsonPath)) {
    try {
      const cfg = JSON.parse(fs.readFileSync(firebaseJsonPath, 'utf8'));
      return cfg?.flutter?.platforms?.android?.default?.projectId ?? null;
    } catch (_) {
      return null;
    }
  }

  return null;
}

const resolvedProjectId = resolveProjectId();
if (!resolvedProjectId) {
  throw new Error('ProjectId not found. Set FIREBASE_PROJECT_ID or configure firebase.json.');
}

admin.initializeApp({ projectId: resolvedProjectId });

const db = admin.firestore();
const seedFilePath = path.join(__dirname, 'seed', 'bible_versions.json');

async function seedBibleVersions() {
  if (!fs.existsSync(seedFilePath)) {
    throw new Error(`Seed file not found: ${seedFilePath}`);
  }

  const raw = fs.readFileSync(seedFilePath, 'utf8');
  const versions = JSON.parse(raw);

  const batch = db.batch();

  for (const item of versions) {
    if (!item.id || !item.storagePath) {
      throw new Error(`Invalid item: ${JSON.stringify(item)}`);
    }

    const docRef = db.collection('bible_versions').doc(item.id);
    batch.set(
      docRef,
      {
        name: item.name ?? item.id,
        storagePath: item.storagePath,
        sizeBytes: item.sizeBytes ?? null,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true }
    );
  }

  await batch.commit();
  console.log(`Seed completed: ${versions.length} bible_versions documents upserted.`);
}

seedBibleVersions()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error('Seed failed:', err);
    process.exit(1);
  });
