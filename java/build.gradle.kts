plugins {
    application
}

repositories {
    mavenCentral()
}

java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(17))
    }
}

application {
    // 기본 엔트리포인트는 Runner로 두고, -Psolution으로 실행할 클래스를 지정
    mainClass.set("runner.Runner")
}

tasks.register<JavaExec>("runSolution") {
    group = "application"
    description = "Run a solution main class: -Psolution=platform.baekjoon.B_0000_Template"

    // toolchain(17) 사용
    javaLauncher.set(javaToolchains.launcherFor {
        languageVersion.set(JavaLanguageVersion.of(17))
    })

    classpath = sourceSets["main"].runtimeClasspath

    val solutionClass = (project.findProperty("solution") as String?)?.trim()
    if (solutionClass.isNullOrEmpty()) {
        throw GradleException("Missing -Psolution=fully.qualified.ClassName")
    }
    mainClass.set(solutionClass)

    // 코테 출력 깔끔하게
    standardInput = System.`in`
}

