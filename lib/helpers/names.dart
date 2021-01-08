const String MARTIN_1 = "eaf2a815-8331-4767-824b-3c875a6aff2b";
const String MARTIN_2 = "480085f1-062f-41f1-8d24-b64a299c0a67";
const String CRIS_1 = "3e4087a4-8e6e-4d06-8970-7837021261d1";
const String CRIS_2 =  "98517983-b729-4959-9d73-beb834b5a3fa";

String faceIdToName(String faceId) {
  switch(faceId) {
    case MARTIN_1: {
      return "Martin Henz";
    }
    break;

    case MARTIN_2: {
      return "Martin Henz";
    }
    break;

    case CRIS_1: {
      return "Cristina Carbunaru";
    }
    break;

    case CRIS_2: {
      return "Cristina Carbunaru";
    }
    break;

    default: {
      return "Sean";
    }
    break;
  }
}