bank <- read.csv("bank-full.csv", sep = ";")

View(bank)

str(bank)

#trasformo variabile di risposta in factor
# Applica la trasformazione solo alle colonne 'character'
bank[sapply(bank, is.character)] <- lapply(bank[sapply(bank, is.character)], as.factor)

#vedere cosa ho dentro y
summary(bank$y)

#vedere cosa ho dentro loans
summary(bank$loan)

#verifico struttura dopo trasformazione
str(bank)

#controllo se in qualche colonna sono presenti NA
colSums(is.na(bank))


#analisi esplorativa per vedere relazioni tra i dati 
install.packages('gridExtra')
install.packages('ggplot2')
library(gridExtra)
library(ggplot2)

# matrice scatterplot con ggplot
install.packages('plotly')
install.packages('GGally')
library(plotly)
library(GGally)

p <- ggpairs(bank, columns = 2:4, ggplot2::aes(colour=y)) 
ggplotly(p)

grf1=ggplot(bank, aes(x=factor(y), fill = y)) + 
  geom_bar()+ 
  labs(title="Grafico a barre per default")+
  ylab("conteggio")+
  xlab("default")
#mostra grafico
grid.arrange(grf1)

#nomi utili per costruire i grafici e cercare di capire cosa mi può essere utile nella mia anlisi per scovare default Yes
names(bank)

install.packages("gridExtra") # Fallo solo una volta
library(gridExtra)
grf2=ggplot(bank, aes(x=y, y=job))+
  geom_boxplot()+
  labs(title="boxlot job")+
  ylab("job")+
  xlab("default")
grid.arrange(grf2)


grf3=ggplot(bank, aes(x=default, y=loan))+
  geom_boxplot()+
  labs(title="boxplot")+
  ylab("prestiti in corso")+
  xlab("default")
grid.arrange(grf3)

grf4=ggplot(bank, aes(x=y, y=education))+
  geom_boxplot()+
  labs(title="boxlot ")+
  ylab("education")+
  xlab("default")
grid.arrange(grf4)


###training del modello
set.seed(1)
# validation set con 67% train e 23% test
training= sample(1:nrow(bank), nrow(bank)*0.67)
test=-training
training=bank[training,]
test=bank[test,]

# 1) LOGISTICA
log= glm(y~1, data=training, family="binomial")
log2= glm(y~., data=training, family="binomial")
summary(log)

# SELEZIONE MIGLIOR MODELLO
install.packages('MASS')
library(MASS)
# library(leaps)
# forward/both selection
step_fit_log = step(log, scope=formula(log2), direction ="both") # FORWARD O both
# step.fit= step(log1, direction="both",trace=TRUE)
summary(step_fit_log)


#miglior modello
#Step:  AIC=14624.65
#y ~ duration + poutcome + month + contact + housing + job + campaign + 
#  marital + loan + day + education


    
    

# predizione
predizione_log = predict(step_fit_log, newdata = test)
# matrice di confusione
confusione_log = table(test$y, predizione_log >0.5)
# accuratezza
sum(diag(confusione_log))/nrow(test)*100  
# Errore di Classificazione
mce_log=(1 - sum(diag(confusione_log))/nrow(test))*100 
# veri positivi (sensitivity)
table(test$y, predizione_log >0.5)
(489/(489+228))*100 # [1]
# falsi positivi (1-specificiti)
(1247/(1247+12956))*100



# 2) LDA - ipotesi normalità confini decisionali, stessa matrice di var/cov dei predittori
# varianza costante tra i predittori
install.packages('MASS')
library(MASS)
lda = lda(y ~ duration + poutcome + month + contact + housing + job + campaign + marital + loan + day + education
          , data = training)
lda
# predizione
predizione_lda = predict(lda, newdata = test)
# matrice di confusione
confusione_lda = table(test$y, predizione_lda$class)
# Accuratezza
sum(diag(confusione_lda))/nrow(test)     #
# Errore di Classificazione
mce_lda=(1 - sum(diag(confusione_lda))/nrow(test))*100 # 
mce_lda
table(test$y, predizione_lda$class)
# veri positivi (sensitivity)
804 / (932 + 804) * 100 #[1] veri positivi
# falsi positivi (1-specificiti)
523 / (523 + 12661) #falsi positivi

# 3) QDA - confini decisionali quadratici, matrice var/cov per ogni predittore
# varianza non costante tra i predittori
qda = qda(y ~ duration + poutcome + month + contact + housing + job + campaign + marital + loan + day + education
          , data = training)
qda
# predizione
predizione_qda = predict(qda, newdata = test)
# matrice di confusione
confusione_qda = table(test$y, predizione_qda$class)
confusione_qda
# Eaccuratezza
sum(diag(confusione_qda))/nrow(test)     
# Errore di classificazione
mce_qda= (1- sum(diag(confusione_qda))/nrow(test))*100
mce_qda
# veri positivi (sensitivity)
table(test$y, predizione_qda$class)
848 / (848 + 888) * 100
# falsi positivi (1-specificiti)
(907/(12277+907))*100 # 


# CV- cross validation K=5(K-FOLD) e K=n(LOOCV)
install.packages('caret')
library(caret)
ctrl_kcv = trainControl(method="cv", number = 5)   #utilizziamo k_fold con k = 5 come approssimazione della LOOCV
ctrl_loocv = trainControl(method="cv", number = nrow(bank)) # metodo con la LOOCV


# 1) LOGISTICA
kfold_log = train(y ~ duration + poutcome + month + contact + housing + job + campaign + marital + loan + day + education
          , data = bank, trControl = ctrl_kcv, method= "glm") # K-FOLD CV)
kfold_log

mce_kcv_log=round((1 - 0.9015063),5)*100

loocv_lda = train(y ~ duration + poutcome + month + contact + housing + job + campaign + marital + loan + day + education
                  , data = bank, trControl = ctrl_kcv, method= "lda") # LOOCV)
loocv_lda
mce_loocv_qda=round((1 -  0.9005332),5)*100


# 2) KNN
kfold_knn = train(y ~ duration + poutcome + month + contact + housing + job + campaign + marital + loan + day + education,
  data = bank,
  trControl = ctrl_kcv,
  method = "knn"
)

kfold_knn
exists("kfold_knn") #mi serviva per capire se stava funzionando, non visualizzavo niente 

# con k=9 si ha miglior modello con accurancy a 88.41%
# errore di classificazione
mce_kcv_knn=round((1 - 0.8841433),5)*100 # 
mce_kcv_knn

#scegliere il modello migliore
mce_modelli=which.min(round(c(mce_log,
                              mce_lda,
                              mce_kcv_knn),4))

mce_modelli