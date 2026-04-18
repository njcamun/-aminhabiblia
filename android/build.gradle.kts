allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

buildscript {
    repositories {
        google()       // <--- GARANTA QUE ESTA LINHA ESTÁ PRESENTE
        mavenCentral() // <--- GARANTA QUE ESTA LINHA ESTÁ PRESENTE
    }
    // ...
    dependencies {
        // ... outras dependências
        classpath("com.google.gms:google-services:4.4.1")  // <--- ADICIONE ESTA LINHA (verifique a versão mais recente no console do Firebase)
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
